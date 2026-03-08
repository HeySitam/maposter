# MapToPoster Mobile App — Full Implementation Roadmap

A version-by-version implementation plan to build a Flutter mobile app that generates map posters from OpenStreetMap data, with progressive features from wallpaper mode through full AR wall preview with lighting effects.

> **Validation note:** This roadmap has been reviewed and corrected by a cross-platform mobile expert. All known technical errors from the original draft have been fixed inline. See each section for correction callouts.

---

## Table of Contents

- [Reference: Python Codebase to Port](#reference-python-codebase-to-port)
- [Platform Prerequisites](#platform-prerequisites)
- [v1 — Generate Poster + Export PNG/PDF](#v1--generate-poster--export-pngpdf) (6-8 weeks)
- [v1.5 — Mobile Wallpaper Application](#v15--mobile-wallpaper-application) (2-3 weeks)
- [v2 — 2D Wall Mockup](#v2--2d-wall-mockup) (2-3 weeks)
- [v3 — AR Wall Preview](#v3--ar-wall-preview) (5-7 weeks)
- [v4 — AR + Light Estimation + Shadows + Occlusion](#v4--ar--light-estimation--shadows--occlusion) (3-4 weeks)
- [Learning Roadmap Summary](#learning-roadmap-summary)
- [Testing Strategy](#testing-strategy)
- [External APIs and Rate Limits](#external-apis-and-rate-limits-reference)
- [Cost Breakdown](#cost-breakdown)

---

## Version Overview

```
v1   ———— Generate poster + export PNG/PDF          [Core Engine]         6-8 weeks
  |
v1.5 ———— Mobile wallpaper application              [Mass market pivot]   2-3 weeks
  |
v2   ———— 2D wall mockup                            [Engagement feature]  2-3 weeks
  |
v3   ———— AR wall preview                           [Wow factor]          5-7 weeks
  |
v4   ———— AR + light/shadows/occlusion              [Polish & premium]    3-4 weeks

Total estimated timeline: 18-25 weeks (experienced Flutter developer)
Total estimated timeline: 29-42 weeks (learning Flutter from scratch)
```

> **Timeline note (original vs. corrected):** The original draft estimated 13-19 weeks total. That assumes prior Flutter and native mobile experience. The v3 estimate was the most optimistic — AR integration consistently takes longer due to native debugging overhead even with existing plugins.

---

## Platform Prerequisites

Decide these at project start. They affect the entire dependency chain.

| Requirement | Value | Reason |
|---|---|---|
| Android `minSdkVersion` | **24** (Android 7.0) | Required for ARCore in v3; reasonable floor for modern deps |
| iOS deployment target | **13.0** | ARKit people segmentation, `SearchBar` widget, `withValues` Color API |
| ARCore support | Devices on [ARCore supported list](https://developers.google.com/ar/devices) — not all Android 7+ qualify | |
| ARKit support | iPhone 6s+ (A9 chip), iOS 11+ basic, iOS 13+ for people segmentation | |
| LiDAR (v4 depth occlusion) | iPhone 12 Pro+, iPad Pro 2020+ | Required for `personSegmentationWithDepth` only |

Set these in `android/app/build.gradle` and `ios/Podfile` on day one.

---

## Dart Conventions & Shorthands

This codebase uses modern Dart shorthands extensively. All contributors should be familiar with these patterns before writing code.

> **Version gate:** Dot shorthand (`.value` syntax) requires **Dart 3.10+**. Flutter 3.41's release notes report Dart 3.9 — verify your actual Dart version with `dart --version` before using dot shorthand. If it shows 3.10+, you're clear. If 3.9, hold off on dot shorthand until the next Flutter stable.

### 1. Dot Shorthand (Static Member Shorthand) — Dart 3.10+

Omit the type name when the compiler can infer it from context. Works for enums, static members, named constructors, and `.new()`.

```dart
// Enums — most common usage in this codebase
RoadType type = .motorway;              // instead of RoadType.motorway
FeatureType ft = .water;               // instead of FeatureType.water
WallpaperTarget t = .lockScreen;       // instead of WallpaperTarget.lockScreen

// Static members
final controller = ScrollController(); // .new() inferred
List<int> zeros = .filled(5, 0);       // instead of List.filled(5, 0)

// Right-hand side of == only (left-hand side is invalid)
if (roadType == .motorway) { }         // valid
if (.motorway == roadType) { }         // INVALID — won't compile

// In function arguments when param type is known
void renderRoad(RoadType type) { }
renderRoad(.primary);                  // instead of renderRoad(RoadType.primary)

// In switch expressions (most impactful usage)
final color = switch (roadType) {
  .motorway         => theme.roadMotorway,
  .primary          => theme.roadPrimary,
  .secondary        => theme.roadSecondary,
  .tertiary         => theme.roadTertiary,
  .residential      => theme.roadResidential,
};
```

### 2. Records — Dart 3.0+

Lightweight anonymous tuples. Replace single-purpose two-field classes and `Offset`/`LatLng` pairs.

```dart
// Coordinate pairs — replaces custom LatLng where a full class is overkill
typedef LatLon = (double lat, double lon);
final center = (48.8566, 2.3522);           // Paris
final (lat, lon) = center;                  // destructure

// Named fields for clarity
typedef Bounds = ({double north, double south, double east, double west});
final bounds = (north: 48.9, south: 48.8, east: 2.4, west: 2.3);
final (:north, :south, :east, :west) = bounds;  // shorthand object pattern

// Return multiple values without a class
(double scaleX, double scaleY) computeScale(Size canvas, Bounds bounds) {
  return (canvas.width / (bounds.east - bounds.west),
          canvas.height / (bounds.north - bounds.south));
}
final (scaleX, scaleY) = computeScale(size, bounds);
```

### 3. Switch Expressions — Dart 3.0+

Expressions (not statements) that return a value. Use instead of if-else chains or switch statements for value lookups.

```dart
// Road color lookup — replaces get_edge_colors_by_type() from Python
Color colorFor(RoadType type, MapTheme theme) => switch (type) {
  .motorway    => theme.roadMotorway,
  .primary     => theme.roadPrimary,
  .secondary   => theme.roadSecondary,
  .tertiary    => theme.roadTertiary,
  .residential => theme.roadResidential,
  .unknown     => theme.roadDefault,
};

// Road width lookup — replaces get_edge_widths_by_type() from Python
double widthFor(RoadType type) => switch (type) {
  .motorway    => 1.2,
  .primary     => 1.0,
  .secondary   => 0.8,
  .tertiary    => 0.6,
  .residential || .unknown => 0.4,  // logical-or pattern
};

// OSM highway tag → RoadType (replaces Python highway string matching)
RoadType roadTypeFrom(String? highway) => switch (highway) {
  'motorway' || 'motorway_link'                    => .motorway,
  'trunk' || 'trunk_link' || 'primary' || 'primary_link' => .primary,
  'secondary' || 'secondary_link'                  => .secondary,
  'tertiary' || 'tertiary_link'                    => .tertiary,
  'residential' || 'living_street' || 'unclassified' => .residential,
  _ => .unknown,
};
```

### 4. Patterns & Destructuring — Dart 3.0+

```dart
// if-case for type-safe JSON parsing
if (json['lat'] case final String latStr) {
  final lat = double.parse(latStr);
}

// Map pattern for OSM node parsing
if (element case {'type': 'node', 'id': int id, 'lat': num lat, 'lon': num lon}) {
  nodeMap[id] = (lat.toDouble(), lon.toDouble());
}

// List pattern for coordinate pairs
final [first, ...rest] = wayNodes;

// Wildcard _ for unused variables
for (final (_, value) in someMap.entries) { }

// Object pattern with shorthand field names (:field = field: field)
for (final MapEntry(:key, :value) in themeMap.entries) {
  print('$key: $value');
}
```

### 5. Constructor Shorthands — all Dart versions

```dart
// Initializing formals — this.x in constructor params
class RoadSegment {
  final List<LatLon> coordinates;
  final RoadType type;
  RoadSegment(this.coordinates, this.type); // no body needed
}

// Super parameters — forward to parent without re-listing
class CachedGeocodingService extends GeocodingService {
  CachedGeocodingService(super.httpClient, this.cache);
  final CacheService cache;
}

// Constructor tear-offs — pass constructor as a function reference
final themes = themeNames.map(MapTheme.fromName).toList();
```

---

## Reference: Python Codebase to Port

The existing Python project follows this pipeline:

```
CLI (argparse) --> Geocoding (Nominatim) --> Data Fetch (OSMnx/Overpass) --> Rendering (matplotlib) --> Export (PNG/SVG/PDF)
```

Key source files to reference while building:

| File | Purpose | Lines |
|------|---------|-------|
| `create_map_poster.py` | Main pipeline: geocoding, fetching, rendering, export | 1052 |
| `font_management.py` | Font loading + Google Fonts download | 171 |
| `themes/terracotta.json` | Theme structure (12 color keys) | 15 |

---

## v1 — Generate Poster + Export PNG/PDF

**Goal:** User types a city name, sees a styled map poster, exports it.
**Estimated effort:** 6-8 weeks

---

### v1.1 — Project Setup and Architecture

**What to build:**
- Flutter project with feature-first folder structure
- State management setup
- Core domain models
- Linting and analysis configuration

**Folder structure:**

```
lib/
  core/
    constants/       # AppConstants (URLs, defaults, paths)
    errors/          # Sealed AppException hierarchy
    network/         # dio_client.dart (buildNominatimDio/buildOverpassDio), rate_limiter.dart
    styles/          # app_colors.dart (AppColors, ThemeData), app_styles.dart (AppInsets, AppText, etc.)
    utils/           # mercator.dart (LatLon typedef, Mercator class), color_converter.dart
  features/
    poster/
      data/
        datasources/ # nominatim_datasource.dart, overpass_datasource.dart, theme_datasource.dart
        repositories/ # geocoding_repository_impl.dart, map_data_repository_impl.dart, theme_repository_impl.dart
      domain/
        entities/    # map_theme.dart, city_coordinates.dart, map_data.dart (all freezed)
        repositories/ # geocoding_repository.dart, map_data_repository.dart, theme_repository.dart (interfaces)
        usecases/    # get_poster_data.dart, export_poster.dart
      presentation/
        screens/     # home_screen.dart, poster_preview_screen.dart
        providers/   # poster_provider.dart, theme_provider.dart
        widgets/     # theme_picker.dart, city_search.dart, export_sheet.dart, map_poster.dart
  app.dart
  main.dart
assets/
  themes/            # All 17 JSON theme files ported from Python (id derived from filename)
```

> **Correction from original draft:** The original used a flat `core/models/` + `core/services/` structure. The actual implementation uses clean architecture with `domain/` (interfaces + entities), `data/` (implementations + datasources), and `presentation/` layers inside each feature. The `core/` layer contains only cross-cutting concerns (network, styles, utils, errors). Fonts are loaded at runtime via `google_fonts` — no font assets directory needed.

**Key dependencies (pubspec.yaml):**

```yaml
dependencies:
  flutter_riverpod: ^2.6.1    # State management
  riverpod_annotation: ^2.6.1 # @riverpod code-gen annotations
  freezed_annotation: ^3.0.0  # Immutable data classes — NOTE: must be ^3.0.0 for custom_lint compat
  json_annotation: ^4.9.0     # JSON serialization (use with build_runner)
  dio: ^5.8.0                  # HTTP client (Nominatim, Overpass) — replaces http
  pretty_dio_logger: ^1.4.0   # Request/response logging in debug mode only
  hive_flutter: ^1.1.0        # Local caching
  google_fonts: ^6.2.1        # Dynamic font loading (no font assets directory needed)
  path_provider: ^2.1.5       # App documents directory
  share_plus: ^10.1.4         # Share sheet
  gal: ^2.3.1                 # Save to gallery — replaces image_gallery_saver
  pdf: ^3.11.2                # PDF generation (pure Dart)
  cupertino_icons: ^1.0.8     # iOS icons

dev_dependencies:
  build_runner: ^2.4.15       # Code generation for freezed + json_serializable + riverpod
  freezed: ^3.0.0             # Code generation for immutable models
  json_serializable: ^6.9.4   # Code generation for JSON
  riverpod_generator: ^2.6.3  # @riverpod code generation
  custom_lint: ^0.7.5         # Lint plugin framework
  riverpod_lint: ^2.6.3       # Riverpod-specific lint rules
  flutter_lints: ^5.0.0       # Flutter lint rules
  flutter_test:               # Unit and widget tests
```

Run code generation with:
```
fvm dart run build_runner build --delete-conflicting-outputs
```

> **Correction:** The original draft used `http`. The actual implementation uses `dio` (with `BaseOptions`, interceptors, and timeout config per client) + `pretty_dio_logger` (added only when `kDebugMode` is true). Dio provides a much better interceptor story for rate limiting, error wrapping, and timeout handling.

> **Correction:** `freezed_annotation` must be `^3.0.0` — `custom_lint >=0.7.4` requires `freezed_annotation ^3.0.0` and will conflict if you use `^2.x`.

> **Addition:** `riverpod_annotation` + `riverpod_generator` + `custom_lint` + `riverpod_lint` enable `@riverpod` codegen annotations and provide lint rules for provider correctness. Add `analysis_options.yaml` with `flutter_lints` and the `custom_lint` plugin on day one.

**Android permissions — add to `AndroidManifest.xml` now:**

```xml
<uses-permission android:name="android.permission.INTERNET" />
<!-- For gal (gallery save) on Android 13+: -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<!-- Legacy Android 12 and below: -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28" />
```

**iOS permissions — add to `Info.plist` now:**

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Saves your map poster to Photos.</string>
```

**Things to learn:** Flutter project architecture, Riverpod basics, feature-first folder structure, `build_runner` code generation.

---

### v1.2 — Domain Models and Theme System

**What to build:**
- Dart models that mirror the Python theme JSON structure
- Theme loader from bundled assets

**Port from Python:** The theme JSON structure from `themes/terracotta.json`:

```dart
import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:map_to_poster/core/utils/color_converter.dart';

part 'map_theme.freezed.dart';
part 'map_theme.g.dart';

@freezed
abstract class MapTheme with _$MapTheme {
  const MapTheme._(); // private constructor for custom methods

  const factory MapTheme({
    required String id,           // injected from filename — NOT in JSON
    required String name,
    required String description,
    @ColorConverter() required Color bg,
    @ColorConverter() required Color text,
    @JsonKey(name: 'gradient_color') @ColorConverter() required Color gradientColor,
    @ColorConverter() required Color water,
    @ColorConverter() required Color parks,
    @JsonKey(name: 'road_motorway') @ColorConverter() required Color roadMotorway,
    @JsonKey(name: 'road_primary') @ColorConverter() required Color roadPrimary,
    @JsonKey(name: 'road_secondary') @ColorConverter() required Color roadSecondary,
    @JsonKey(name: 'road_tertiary') @ColorConverter() required Color roadTertiary,
    @JsonKey(name: 'road_residential') @ColorConverter() required Color roadResidential,
    @JsonKey(name: 'road_default') @ColorConverter() required Color roadDefault,
  }) = _MapTheme;

  factory MapTheme.fromJson(Map<String, dynamic> json) => _$MapThemeFromJson(json);

  // Custom method — possible because of private constructor + const MapTheme._()
  Color roadColor(String roadType) => switch (roadType) {
    'motorway' || 'trunk'              => roadMotorway,
    'primary'                          => roadPrimary,
    'secondary'                        => roadSecondary,
    'tertiary'                         => roadTertiary,
    'residential' || 'living_street'   => roadResidential,
    _                                  => roadDefault,
  };
}
```

> **CRITICAL — freezed 3.x requires `abstract class`:** In freezed 3.x the generated mixin uses abstract getters. If you write `class MapTheme with _$MapTheme` you will get a compile error: _"Missing concrete implementation of..."_. You MUST write `abstract class MapTheme with _$MapTheme`. This applies to every freezed class in the project.

> **`id` injection:** The `id` field is not present in the theme JSON files (it's derived from the filename). Before calling `MapTheme.fromJson`, inject it manually: `json['id'] = id;`. This avoids needing `@JsonKey(includeFromJson: false)` hacks.

> **`ColorConverter`:** Colors in JSON are hex strings like `"#1A2B3C"`. Create a `ColorConverter` implementing `JsonConverter<Color, String>`. Use `color.r/g/b * 255` — NOT the deprecated `color.value`. Apply as `@ColorConverter()` on each Color field.

Other models needed:

```dart
// Coordinate pair as a record — lightweight, no class needed
typedef LatLon = (double lat, double lon);

// Bounding box as a named-field record
typedef LatLonBounds = ({double north, double south, double east, double west});

@freezed
abstract class CityCoordinates with _$CityCoordinates {
  const factory CityCoordinates({
    required double latitude,
    required double longitude,
    required String displayName,
    String? city,     // extracted from Nominatim address field
    String? country,  // extracted from Nominatim address field
  }) = _CityCoordinates;
  // No fromJson — constructed manually from Nominatim response JSON
}

enum RoadType { motorway, primary, secondary, tertiary, residential, unknown }
enum FeatureType { water, park }

@freezed
abstract class RoadSegment with _$RoadSegment {
  const factory RoadSegment({
    required List<LatLon> coordinates, // Geographic records, NOT screen coords
    required RoadType type,
  }) = _RoadSegment;
}

@freezed
abstract class MapFeature with _$MapFeature {
  const factory MapFeature({
    required List<List<LatLon>> rings, // Outer ring + inner rings (holes)
    required FeatureType type,
  }) = _MapFeature;
}

@freezed
abstract class MapData with _$MapData {
  const MapData._();

  const factory MapData({
    required List<RoadSegment> roads,
    required List<MapFeature> waterFeatures,
    required List<MapFeature> parkFeatures,
    required LatLonBounds bounds,
  }) = _MapData;

  List<MapFeature> get allFeatures => [...waterFeatures, ...parkFeatures];
}
```

> **Correction:** The original draft used `List<Offset>` (screen coordinates) in `RoadSegment`. Models should store geographic `LatLon` coordinates. Screen projection happens at render time, not at data model time — this separation is critical for supporting multiple canvas sizes and re-renders.

> **Model-entity collapse:** freezed classes serve as both domain entities and data models. There is no need for separate `MapThemeModel`/`CityCoordinatesModel` wrapper classes. Repository interfaces live in `domain/`, implementations in `data/` — clean architecture boundaries are maintained through interfaces, not class duplication.

**Theme validation — add required key check:**

```dart
// In theme loader, validate all required keys are present before returning
const requiredKeys = ['bg', 'text', 'gradient_color', 'water', 'parks',
  'road_motorway', 'road_primary', 'road_secondary', 'road_tertiary',
  'road_residential', 'road_default'];

for (final key in requiredKeys) {
  if (!json.containsKey(key)) {
    throw FormatException('Theme missing required key: $key');
  }
}
```

**Things to learn:** Dart data classes with `freezed` (requires `abstract class` in freezed 3.x), JSON serialization with `@JsonKey` and custom `JsonConverter`, Flutter asset bundling, `Color` parsing from hex strings, `color.r/g/b` vs deprecated `color.value`, `AppColors`/`AppStyles` design system pattern (Wonderous-inspired), `GoogleFonts` runtime loading.

---

### v1.3 — Geocoding Service

**What to build:**
- HTTP call to Nominatim API
- Response parsing
- Local caching with Hive
- Correct rate limiting via a request queue

**Port from Python:** `get_coordinates()` function (lines 319-370 of `create_map_poster.py`)

---

**Datasource directory convention (applies to all datasources, v1.3 onwards):**

Every datasource is split into `remote/` and `local/` subdirectories. Each subdirectory contains an `abstract interface class` contract and a concrete `*Impl` class:

```
data/datasources/
  remote/
    nominatim_remote_datasource.dart          # abstract interface class
    nominatim_remote_datasource_impl.dart     # Dio + RateLimiter
  local/
    nominatim_local_datasource.dart           # abstract interface class
    nominatim_local_datasource_impl.dart      # Hive Box<dynamic>
    theme_local_datasource.dart               # abstract interface class
    theme_local_datasource_impl.dart          # rootBundle asset loader
```

**Rules:**
- Repositories depend on **interfaces only** — never on Hive/Dio types directly
- Hive `Box` is injected into the local datasource impl via the provider — not passed to the repo
- `providers.dart` types all datasource providers against their interfaces
- Future datasources (Overpass) follow the same pattern: `overpass_remote_datasource.dart` + impl

---

**Remote datasource (Nominatim API):**

```dart
// remote/nominatim_remote_datasource.dart
abstract interface class NominatimRemoteDatasource {
  Future<CityCoordinates> searchCity(String city, String country);
}

// remote/nominatim_remote_datasource_impl.dart
class NominatimRemoteDatasourceImpl implements NominatimRemoteDatasource {
  NominatimRemoteDatasourceImpl(this._dio, this._rateLimiter);

  final Dio _dio;         // built via buildNominatimDio()
  final RateLimiter _rateLimiter;

  @override
  Future<CityCoordinates> searchCity(String city, String country) =>
      _rateLimiter.run(() async {
        final response = await _dio.get<List<dynamic>>(
          '/search',
          queryParameters: {'q': '$city,$country', 'format': 'json', 'limit': 1, 'addressdetails': 1},
        );
        final results = response.data;
        if (results == null || results.isEmpty) {
          throw GeocodingException('No results found for "$city, $country"');
        }
        final data = results.first as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;
        return CityCoordinates(
          latitude: double.parse(data['lat'] as String),
          longitude: double.parse(data['lon'] as String),
          displayName: data['display_name'] as String,
          city: address?['city'] as String? ??
              address?['town'] as String? ??
              address?['village'] as String?,
          country: address?['country'] as String?,
        );
      });
}
```

**Local datasource (Hive cache):**

```dart
// local/nominatim_local_datasource.dart
abstract interface class NominatimLocalDatasource {
  CityCoordinates? get(String key);
  Future<void> put(String key, CityCoordinates coordinates);
}

// local/nominatim_local_datasource_impl.dart
class NominatimLocalDatasourceImpl implements NominatimLocalDatasource {
  NominatimLocalDatasourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  CityCoordinates? get(String key) {
    final cached = _box.get(key) as Map?;
    if (cached == null) return null;
    return CityCoordinates(
      latitude: cached['latitude'] as double,
      longitude: cached['longitude'] as double,
      displayName: cached['displayName'] as String,
      city: cached['city'] as String?,
      country: cached['country'] as String?,
    );
  }

  @override
  Future<void> put(String key, CityCoordinates coordinates) => _box.put(key, {
    'latitude': coordinates.latitude,
    'longitude': coordinates.longitude,
    'displayName': coordinates.displayName,
    'city': coordinates.city,
    'country': coordinates.country,
  });
}
```

**Repository (cache-aside, depends on interfaces only):**

```dart
class GeocodingRepositoryImpl implements GeocodingRepository {
  const GeocodingRepositoryImpl(this._remote, this._local);

  final NominatimRemoteDatasource _remote;
  final NominatimLocalDatasource _local;

  @override
  Future<CityCoordinates> getCoordinates(String city, String country) async {
    final key = 'geocoding_${city.toLowerCase().trim()}_${country.toLowerCase().trim()}';
    final cached = _local.get(key);
    if (cached != null) return cached;
    final result = await _remote.searchCity(city, country);
    await _local.put(key, result);
    return result;
  }
}
```

**Hive init in `main()`:**

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AppConstants.geocodingCacheBoxName);
  runApp(const ProviderScope(child: App()));
}
```

> **Correction:** The original draft used `http.get(...)` and `jsonDecode`. The actual implementation uses `Dio` with `buildNominatimDio()` which pre-sets `BaseOptions` (base URL, User-Agent, Accept header, timeouts) and attaches `_AppInterceptor` (wraps `DioException` → typed `NetworkException`) and `PrettyDioLogger` (debug mode only). `response.data` is already decoded by Dio — no `jsonDecode` call needed.

> **Correction:** The original draft used `await Future.delayed(Duration(seconds: 1))` directly. This does NOT enforce rate limiting for concurrent calls — each call delays independently and all fire at the same time. The `RateLimiter` class above chains requests sequentially, matching the Python `time.sleep(1)` behaviour.

**Things to learn:** `dio` package (`Dio`, `BaseOptions`, `Interceptor`), `abstract interface class` pattern in Dart, Hive box operations, async/await patterns, Nominatim API response format (`addressdetails=1` for city/country), Future chaining for sequential queuing.

---

### v1.4 — Overpass API Integration

**What to build:**
- Overpass QL query builder
- Response parser (nodes, ways, relations to geometry)
- Separate fetchers for roads, water, and parks
- Background isolate for parsing large responses

**Port from Python:** `fetch_graph()` (lines 409-441) and `fetch_features()` (lines 444-479).

**Important — compensated_dist:**
The Python code over-fetches data with a compensated distance before cropping to the poster aspect ratio (line 534 of `create_map_poster.py`):

```python
compensated_dist = dist * (max(height, width) / min(height, width)) / 4
```

Port this to Dart and use `compensatedDist` in all three Overpass queries below, or roads near poster edges will be missing.

```dart
double computeCompensatedDist(double dist, double width, double height) =>
    dist * (max(height, width) / min(height, width)) / 4;
```

**Overpass QL queries to construct:**

For roads (replaces `ox.graph_from_point`):
```
[out:json][timeout:60];
(
  way["highway"](around:{compensatedDist},{lat},{lon});
);
out body; >; out skel qt;
```

For water (replaces `ox.features_from_point` with water tags):
```
[out:json][timeout:60];
(
  way["natural"~"water|bay|strait"](around:{compensatedDist},{lat},{lon});
  relation["natural"~"water|bay|strait"](around:{compensatedDist},{lat},{lon});
  way["waterway"="riverbank"](around:{compensatedDist},{lat},{lon});
);
out body; >; out skel qt;
```

For parks:
```
[out:json][timeout:60];
(
  way["leisure"="park"](around:{compensatedDist},{lat},{lon});
  way["landuse"="grass"](around:{compensatedDist},{lat},{lon});
);
out body; >; out skel qt;
```

**Response parsing — this is the hardest part of v1:**

Overpass returns nodes and ways separately. Steps:

1. Build a node lookup: `Map<int, LatLon>` from all `type: "node"` elements — use map pattern
2. For each `type: "way"`, resolve `nodes` array into `List<LatLon>` via the lookup
3. Classify roads by `highway` tag via switch expression with dot shorthand
4. For water/parks, a closed way (first node ID == last node ID) is a polygon
5. For relations (multipolygon lakes, parks), assemble rings from member ways:

```dart
// Node parsing with map pattern destructuring
final nodeMap = <int, LatLon>{};
for (final element in elements) {
  if (element case {'type': 'node', 'id': int id, 'lat': num lat, 'lon': num lon}) {
    nodeMap[id] = (lat.toDouble(), lon.toDouble());
  }
}

// Road classification — switch expression with dot shorthand
RoadType roadTypeFrom(Object? highway) => switch (highway) {
  'motorway' || 'motorway_link'                          => .motorway,
  'trunk' || 'trunk_link' || 'primary' || 'primary_link' => .primary,
  'secondary' || 'secondary_link'                        => .secondary,
  'tertiary' || 'tertiary_link'                          => .tertiary,
  'residential' || 'living_street' || 'unclassified'     => .residential,
  _                                                      => .unknown,
};

// Multipolygon relation assembly — non-trivial graph problem:
// - Member ways are NOT in order
// - Ways may need to be reversed (connect end-to-start)
// - Must produce: one outer ring + zero or more inner rings (holes)
List<List<LatLon>> assembleMultipolygon(List<Way> memberWays) {
  // 1. Separate 'outer' and 'inner' role members using pattern matching
  final outers = [for (final w in memberWays) if (w case Way(role: 'outer')) w];
  final inners = [for (final w in memberWays) if (w case Way(role: 'inner')) w];
  // 2. For outer members: chain ways by matching endpoints (may need reversal)
  // 3. For inner members: same chaining process for hole rings
  // 4. Return [outerRing, ...innerRings]
}
```

> **Important:** The original draft treated multipolygon assembly as a single bullet point. In practice this is a 3-5 day implementation task. OSM ways within a relation have no guaranteed order and may need to be reversed to form a continuous ring. Consider using the `turf_dart` package for geometry helpers, or budget 3-5 days for this algorithm alone.

**Run parsing in a background isolate to avoid UI freezes:**

Large city responses (15-20km radius) can be 10-50 MB of JSON. Parsing on the main thread causes 2-4 second UI freezes.

```dart
// In your Riverpod provider or service:
final mapData = await compute(_parseOverpassResponse, rawJsonString);

// Top-level function (required for compute()):
MapData _parseOverpassResponse(String json) {
  // All parsing logic here — runs in a separate isolate
}
```

**Caching:** Cache parsed `MapData` in Hive, keyed by `"{lat}_{lon}_{compensatedDist}_{type}"`.

**Things to learn:** Overpass QL syntax, OSM data model (nodes/ways/relations), multipolygon relation assembly, `compute()` isolates, efficient `Map` lookups in Dart.

---

### v1.5 — Mercator Projection

**What to build:**
- Convert lat/lon coordinates to screen pixel coordinates
- Bounding box calculation and viewport fitting

**Port from Python:** `get_crop_limits()` (lines 373-406). In Dart, implement Web Mercator directly:

```dart
class MercatorProjection {
  /// Projects geographic coordinates to Mercator space (unitless, not pixels yet).
  /// Returns a record instead of Offset — no Flutter dependency on pure math.
  (double x, double y) project(double lat, double lon) => (
    lon * pi / 180,
    log(tan(pi / 4 + lat * pi / 360)), // Standard Web Mercator formula
  );

  /// Projects a list of LatLon records to screen-space Offsets, preserving aspect ratio.
  /// Mirrors Python's get_crop_limits() — crops inward to match canvas aspect.
  List<Offset> projectToScreen(
    List<LatLon> coords,
    Size canvasSize,
    LatLonBounds bounds,
  ) {
    final (x: tlX, y: tlY) = project(bounds.north, bounds.west);
    final (x: brX, y: brY) = project(bounds.south, bounds.east);

    final mercWidth  = (brX - tlX).abs();
    final mercHeight = (tlY - brY).abs();

    final aspect = canvasSize.width / canvasSize.height;
    final scale = aspect > mercWidth / mercHeight
        ? canvasSize.height / mercHeight   // canvas wider — fit by height
        : canvasSize.width / mercWidth;    // canvas taller — fit by width

    return [
      for (final (lat, lon) in coords)
        Offset(
          (project(lat, lon).$1 - tlX) * scale,
          (tlY - project(lat, lon).$2) * scale, // Y inverted (screen Y grows down)
        ),
    ];
  }
}
```

> **Note:** Python uses `ox.project_graph()` which projects to a local metric CRS (UTM), not Web Mercator. For cities below ~60°N the difference is negligible (<1% distortion). Web Mercator is fine for this use case.

**Things to learn:** Web Mercator projection math, coordinate reference systems, aspect ratio preservation.

---

### v1.6 — Rendering Engine (CustomPainter)

**What to build:**
- Multi-layer `CustomPainter` that draws the complete poster
- Layer order matching the Python rendering pipeline
- Path batching for road performance

**Port from Python:** The rendering in `create_poster()` (lines 482-772). The z-order is:

```
z=0    Background fill
z=0.5  Water polygons
z=0.8  Park polygons
z=3    Roads (with per-type color and width)
z=10   Gradient fades (top and bottom)
z=11   Text labels (city, country, coordinates, divider line, attribution)
```

```dart
class MapPosterPainter extends CustomPainter {
  final MapData mapData;
  final MapTheme theme;
  final String cityName;
  final String countryName;
  final double lat, lon;
  final MercatorProjection projection;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawWater(canvas, size);
    _drawParks(canvas, size);
    _drawRoads(canvas, size);
    _drawGradientFades(canvas, size);
    _drawTextLabels(canvas, size);
  }

  @override
  bool shouldRepaint(MapPosterPainter old) =>
      old.theme != theme || old.mapData != mapData;
}
```

**Road rendering — batch by type for performance:**

A large city can have 50,000-200,000 road segments. Calling `canvas.drawPath()` per segment causes severe raster thread stalls. Batch roads by type into one `Path` per road class — 5-6 draw calls total instead of 100k+.

```dart
void _drawRoads(Canvas canvas, Size size) {
  // Group segments by road type
  final paths = <RoadType, Path>{
    for (final type in RoadType.values) type: Path()
  };

  for (final road in mapData.roads) {
    final projected = projection.projectToScreen(road.coordinates, size, mapData.bounds);
    final path = paths[road.type]!;
    path.moveTo(projected.first.dx, projected.first.dy);
    for (final pt in projected.skip(1)) {
      path.lineTo(pt.dx, pt.dy);
    }
  }

  // One drawPath call per road type — dot shorthand in switch expressions
  for (final MapEntry(:key, :value) in paths.entries) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = switch (key) {
        .motorway    => 1.2,
        .primary     => 1.0,
        .secondary   => 0.8,
        .tertiary    => 0.6,
        .residential || .unknown => 0.4,
      } * scaleFactor
      ..color = switch (key) {
        .motorway    => theme.roadMotorway,
        .primary     => theme.roadPrimary,
        .secondary   => theme.roadSecondary,
        .tertiary    => theme.roadTertiary,
        .residential => theme.roadResidential,
        .unknown     => theme.roadDefault,
      }
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(value, paint);
  }
}
```

> **Correction:** The original draft did not mention path batching. Without it, real city renders will cause severe UI lag. This is not optional.

**Road widths by type** (from `get_edge_widths_by_type()` lines 289-316 of Python) — expressed as a switch expression with dot shorthand:

```dart
double widthFor(RoadType type) => switch (type) {
  .motorway                => 1.2,
  .primary                 => 1.0,
  .secondary               => 0.8,
  .tertiary                => 0.6,
  .residential || .unknown => 0.4,
};
```

**Gradient fade** — Port `create_gradient_fade()` (lines 214-252):

```dart
void _drawGradientFade(Canvas canvas, Size size, {required bool isTop}) {
  final rect = isTop
      ? Rect.fromLTWH(0, 0, size.width, size.height * 0.25)
      : Rect.fromLTWH(0, size.height * 0.75, size.width, size.height * 0.25);

  final gradient = LinearGradient(
    begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
    end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
    // NOTE: withOpacity() is deprecated in Flutter 3.27+. Use withValues().
    colors: [theme.gradientColor, theme.gradientColor.withValues(alpha: 0)],
  );
  canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
}
```

> **Correction:** The original draft used `theme.gradientColor.withOpacity(0)`. `withOpacity()` is deprecated in Flutter 3.27+ — use `Color.withValues(alpha: 0.0)` throughout.

**Text labels** — Port the typography section (lines 629-753). Key details:

- City name: bold, use `TextStyle(letterSpacing: value)` for Latin scripts (cleaner than the Python `"  ".join(list(city.upper()))` space-joining workaround)
- Non-Latin scripts: no letter spacing, preserve case — detected via same `is_latin_script` logic
- Country name: light weight, uppercase
- Coordinates: `"{lat}N / {lon}E"` format
- Divider line between city and country
- Attribution: `"© OpenStreetMap contributors"` bottom-right, 50% opacity
- Dynamic font sizing for long city names (lines 664-672): if > 10 chars, scale down by `10 / charCount`

```dart
void _drawCityLabel(Canvas canvas, Size size) {
  final isLatin = _isLatinScript(cityName);
  final displayCity = isLatin ? cityName.toUpperCase() : cityName;
  final charCount = cityName.length;
  final baseFontSize = 60.0 * scaleFactor;
  final fontSize = charCount > 10
      ? max(baseFontSize * (10 / charCount), 10.0 * scaleFactor)
      : baseFontSize;

  final textPainter = TextPainter(
    text: TextSpan(
      text: displayCity,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: theme.text,
        // Use letterSpacing instead of manual space-joining
        letterSpacing: isLatin ? fontSize * 0.15 : 0,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  )..layout(maxWidth: size.width * 0.9);

  textPainter.paint(
    canvas,
    Offset((size.width - textPainter.width) / 2, size.height * 0.14),
  );
}
```

**Typography positions** (matching Python `transAxes` values):

```
y = 0.14   City name (bold, letter-spaced for Latin)
y = 0.125  Decorative divider line
y = 0.10   Country name (light, uppercase)
y = 0.07   Coordinates (lat/lon)
y = 0.02   Attribution bottom-right, alpha 0.5
```

**Things to learn:** Flutter `CustomPainter`, `Canvas` API (`drawPath`, `drawRect`, `drawLine`), `TextPainter`, `LinearGradient` shaders, `Paint` stroke configuration, `Path` batching.

---

### v1.7 — Export System

**What to build:**
- High-resolution PNG export via `PictureRecorder`
- PDF export via the `pdf` package
- Save to device gallery via `gal`
- Share sheet via `share_plus`

**PNG export:**

```dart
Future<Uint8List> exportPng(
  MapPosterPainter painter,
  Size posterSize, {
  int dpi = 300,
}) async {
  final scale = dpi / 72.0;
  final width = (posterSize.width * scale).toInt();
  final height = (posterSize.height * scale).toInt();

  // Guard against OOM on low-memory devices
  final estimatedMb = (width * height * 4) / (1024 * 1024);
  if (estimatedMb > 150) {
    throw Exception(
      'Export size ${estimatedMb.toStringAsFixed(0)}MB exceeds safe limit. '
      'Reduce DPI or poster dimensions.',
    );
  }

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
  );
  canvas.scale(scale);
  painter.paint(canvas, posterSize);

  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}
```

> **Correction:** The original draft had no memory guard. At 300 DPI, a 12×16 inch poster = 3600×4800px × 4 bytes = ~66 MB uncompressed. On low-memory Android devices `toImage()` will OOM without warning. Add an explicit size check before proceeding, and document the safe limits in the UI.

**Save to gallery:**

```dart
// Using `gal` package (replaces image_gallery_saver)
await Gal.putImageBytes(pngBytes, name: '${city}_${theme}_poster.png');
```

**PDF export:** Use the `pdf` package to draw on a PDF canvas (API mirrors Flutter's Canvas closely). Note that complex vector maps with thousands of paths will produce large PDF files and slow rendering — suitable for print use cases, not real-time preview.

**Things to learn:** `dart:ui` PictureRecorder, image encoding, memory limits on mobile, `gal` plugin, `pdf` package drawing API.

---

### v1.8 — UI Screens

**What to build:**
- Home screen: city search bar + recent cities
- Poster preview screen: live CustomPainter + theme picker + export options
- Theme browser: grid/carousel of all 17 themes with mini-previews
- Loading states with progress indication

**UI flow:**

```
Home Screen (city search + recents)
    |
    v  [Search city]
Loading Screen (geocoding + fetching data — shows per-step progress)
    |
    v  [Data ready]
Poster Preview (live CustomPainter)
    |----> Theme Picker (grid of 17 themes) ----> back to Preview
    |
    v  [Export]
Export Bottom Sheet (PNG / PDF / Share)
    |----> Saved to Gallery
    |----> System Share Sheet
```

> **Correction:** The original draft referenced `SearchDelegate`. That is Material 2 and considered legacy. Use Flutter 3.x `SearchBar` + `SearchAnchor` (Material 3) instead.

**Things to learn:** Flutter widget composition, `BottomSheet`, `SearchBar`/`SearchAnchor`, Riverpod `AsyncValue` for loading/error/data states, `CustomPaint` widget.

---

## v1.5 — Mobile Wallpaper Application

**Goal:** Let users set map posters as phone wallpapers with device-aware sizing.
**Estimated effort:** 2-3 weeks
**Builds on:** The rendering engine from v1

---

### v1.5.1 — Screen-Aware Rendering

**What to build:**
- Detect device screen resolution
- Render poster at exact screen dimensions
- Wallpaper-specific layout adjustments

```dart
class WallpaperConfig {
  final Size screenSize;         // e.g., Size(1290, 2796) for iPhone 15 Pro Max
  final double devicePixelRatio;
  final WallpaperTarget target;  // homeScreen, lockScreen, both
  final bool showLabels;         // Wallpapers often look better without text
  final bool minimalMode;        // Just map, no gradients/labels
}
```

**Screen resolution detection:**

```dart
final screenSize = MediaQuery.of(context).size;
final pixelRatio = MediaQuery.of(context).devicePixelRatio;
final physicalSize = Size(
  screenSize.width * pixelRatio,
  screenSize.height * pixelRatio,
);
```

**Things to learn:** `MediaQuery`, device pixel ratios, adaptive layouts.

---

### v1.5.2 — Wallpaper Setting (Platform-Specific)

**What to build:**
- Android: Direct wallpaper setting via Method Channel to `WallpaperManager`
- iOS: Save to Photos + guided manual instructions (Apple does not allow programmatic wallpaper setting)

**Add to `AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.SET_WALLPAPER" />
```

**Android Method Channel (Kotlin) — must run off main thread:**

```kotlin
class WallpaperMethodChannel(private val context: Context) : MethodChannel.MethodCallHandler {
  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "setWallpaper" -> {
        val bytes = call.argument<ByteArray>("imageBytes")!!
        val target = call.argument<Int>("target")!!
        // IMPORTANT: setBitmap() is blocking IO — must run on background thread
        // Calling it on the main thread causes ANR on large images
        CoroutineScope(Dispatchers.IO).launch {
          try {
            val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            val manager = WallpaperManager.getInstance(context)
            val flag = when (target) {
              0    -> WallpaperManager.FLAG_SYSTEM
              1    -> WallpaperManager.FLAG_LOCK
              else -> WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK
            }
            manager.setBitmap(bitmap, null, true, flag)
            withContext(Dispatchers.Main) { result.success(true) }
          } catch (e: Exception) {
            withContext(Dispatchers.Main) { result.error("WALLPAPER_ERROR", e.message, null) }
          }
        }
      }
    }
  }
}
```

> **Correction:** The original draft called `setBitmap()` synchronously. This is a blocking IO call — executing it on the main thread causes an ANR (Application Not Responding) dialog. Always dispatch to `Dispatchers.IO`.

**iOS — Save + Guide:**

Apple does not allow programmatic wallpaper setting. The flow is:
1. Save image via `gal`
2. Show a modal with clear steps:
   > "Open **Settings** > **Wallpaper** > **Add New Wallpaper** > select from **Recents**"
3. Offer a "Go to Settings" button using `url_launcher` with `openAppSettings()`.

> **Correction:** The original draft suggested deep-linking with `"App-Prefs:root=Wallpaper"`. This is a **private URL scheme** and Apple has historically **rejected App Store submissions** that use it. Use `openAppSettings()` from `permission_handler` or the root Settings URL instead.

**Things to learn:** Method Channels (Dart to Kotlin/Swift), Kotlin coroutines, `WallpaperManager` Android API, iOS `PHPhotoLibrary`, `Platform.isAndroid` / `Platform.isIOS`.

---

### v1.5.3 — Wallpaper-Specific UI

**What to build:**
- Wallpaper preview inside a phone frame mockup
- Toggle between Home Screen / Lock Screen / Both
- Dark/light theme suggestions based on target
- Parallax toggle (Android only)

**Phone frame mockup widget:**

```dart
class PhoneFramePreview extends StatelessWidget {
  final Widget child;
  final bool showClock;    // Simulate lock screen clock overlay
  final bool showWidgets;  // Simulate home screen widget zones
  // Renders child inside a phone-shaped ClipRRect with rounded corners
  // Semi-transparent overlay shows where system UI sits
}
```

> **Note:** Use `ClipRRect` for the phone shape, not `ClipPath`, unless you need an exact device bezel shape. `ClipRRect` is GPU-accelerated; a custom `ClipPath` has a higher rasterization cost.

**Things to learn:** `ClipRRect`, overlay composition with `Stack`, conditional UI by platform.

---

## v2 — 2D Wall Mockup

**Goal:** User uploads/takes a photo of their room, drags the poster onto the wall, resizes it.
**Estimated effort:** 2-3 weeks

---

### v2.1 — Image Picker Integration

**What to build:**
- Camera capture for wall photo
- Gallery picker for existing photos

**Package:** `image_picker` plugin.

**Add to `AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.CAMERA" />
<!-- Android 13+ granular media permissions: -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

**Add to `Info.plist`:**
```xml
<key>NSCameraUsageDescription</key>
<string>Take a photo of your wall to preview the poster.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Select a photo of your wall to preview the poster.</string>
```

**Things to learn:** Camera and gallery permissions, `image_picker` API.

---

### v2.2 — Interactive Poster Placement

**What to build:**
- Drag-to-position the poster on the wall photo
- Pinch-to-resize with simultaneous rotation

```dart
class WallMockupScreen extends StatefulWidget {
  // State:
  //   Offset posterPosition
  //   double posterScale
  //   double posterRotation
  //   File wallPhoto
}
```

> **Correction:** The original draft suggested combining `onPanUpdate` and `onScaleUpdate`. These **conflict** on `GestureDetector` — only one wins. Use `onScaleUpdate` exclusively. It provides translation (`focalPoint`), scale, and rotation simultaneously via `ScaleUpdateDetails`.

```dart
GestureDetector(
  onScaleUpdate: (details) {
    setState(() {
      posterPosition += details.focalPointDelta;  // Translation
      posterScale *= details.scale;               // Scale
      posterRotation += details.rotation;         // Rotation
    });
  },
  child: Transform(
    transform: Matrix4.identity()
      ..translate(posterPosition.dx, posterPosition.dy)
      ..rotateZ(posterRotation)
      ..scale(posterScale),
    child: CustomPaint(painter: mapPosterPainter),
  ),
)
```

**Shadow — correct approach:**

> **Correction:** `BoxShadow` is a `BoxDecoration` property and cannot be applied to a `CustomPainter` directly. Draw the shadow manually on canvas using `canvas.drawShadow()`, or wrap the poster in a `PhysicalModel` widget:

```dart
PhysicalModel(
  color: Colors.transparent,
  elevation: 8.0,
  shadowColor: Colors.black.withValues(alpha: 0.5),
  child: CustomPaint(painter: mapPosterPainter),
)
```

**Perspective warp — scope carefully:**

The roadmap mentions "optional perspective warp using Matrix4 skew". A proper projective transform for angled walls requires a **full homography** (4-point correspondence → solve linear system for the 3×3 matrix). This is not a simple skew — it is a significant feature. Either build a dedicated 4-point drag UI and implement the homography solve, or cut it from v2 scope.

**Things to learn:** `GestureDetector` `onScaleUpdate`, `Matrix4` transforms, `canvas.drawShadow()`, homographic transforms (if perspective warp is in scope).

---

### v2.3 — Composite Export

**What to build:**
- Capture the wall photo + poster composite as a single image
- Share the mockup

```dart
// Wrap the entire mockup in RepaintBoundary with a GlobalKey
final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
final image = await boundary.toImage(pixelRatio: 3.0);
final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
```

**Things to learn:** `RepaintBoundary`, `RenderObject.toImage()`, compositing layers.

---

## v3 — AR Wall Preview

**Goal:** Live camera feed with spatial tracking, user taps a detected wall to place a life-size poster.
**Estimated effort:** 5-7 weeks

> **Timeline correction:** The original draft estimated 3-4 weeks. AR consistently requires more time due to native debugging, device-specific ARCore/ARKit behaviour, and Platform View integration quirks. Budget 5-7 weeks.

---

### v3.1 — AR Foundation Setup

**What to build:**
- Flutter AR integration via existing plugin (see correction below)
- Vertical plane detection
- Device capability check with graceful fallback

> **CRITICAL CORRECTION — Sceneform is deprecated:**
> The original draft referenced "Sceneform/Filament (Android)" as the AR renderer. **Google deprecated and archived Sceneform in 2021.** Do not build against it for a new project.
>
> **Use an existing Flutter AR plugin instead of building raw Platform View bridges from scratch:**
>
> | Option | Platforms | Notes |
> |---|---|---|
> | **`ar_flutter_plugin`** | ARCore + ARKit | Actively maintained Flutter plugin, handles Platform Views and Method Channels. Start here. |
> | **`sceneview_flutter`** | ARCore (SceneView community fork) | More control on Android, ARKit support varies |
> | Raw Platform Views | ARCore + ARKit | Maximum control, maximum effort — only if plugins genuinely don't meet requirements |
>
> Using `ar_flutter_plugin` saves 3-6 weeks of native integration work that the plugin has already solved.

**Platform prerequisites:**

- **Android:** `minSdkVersion 24`, ARCore dependency in `build.gradle`. First-run prompt to install ARCore if not present (handled by the plugin, but be aware of the install flow).
- **iOS:** `NSCameraUsageDescription` in `Info.plist`, deployment target 13.0+.

**Architecture (using `ar_flutter_plugin`):**

```dart
ARView(
  onARViewCreated: _onARViewCreated,
  planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
)

void _onARViewCreated(
  ARSessionManager sessionManager,
  ARObjectManager objectManager,
  ARAnchorManager anchorManager,
  ARLocationManager locationManager,
) {
  _sessionManager = sessionManager;
  _objectManager = objectManager;
  _anchorManager = anchorManager;

  sessionManager.onPlaneOrPointTap = _onPlaneTap;
}
```

**Fallback for unsupported devices:**

```dart
Future<bool> isARSupported() async {
  // ar_flutter_plugin exposes this check
  return await ARSessionManager.checkARSupport();
}

// In UI:
if (!await isARSupported()) {
  // Route user to v2's 2D mockup instead
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WallMockupScreen()));
}
```

**Things to learn:** `ar_flutter_plugin` API, ARCore fundamentals (sessions, planes, anchors), ARKit fundamentals (configurations, plane detection), AR session lifecycle.

---

### v3.2 — Poster Placement in AR

**What to build:**
- Hit-test on detected vertical planes
- Anchor creation at tap point
- Render poster texture on a 3D plane at real-world dimensions
- Gesture controls for repositioning and size selection

**Real-world sizing (correct values):**

| Print Size | Width (m) | Height (m) |
|---|---|---|
| A4 | 0.210 | 0.297 |
| A3 | 0.297 | 0.420 |
| A2 | 0.420 | 0.594 |
| 24 × 36 in | 0.610 | 0.914 |

**Placement (using `ar_flutter_plugin`):**

```dart
Future<void> _onPlaneTap(List<ARHitTestResult> results) async {
  final hit = results.firstWhere(
    (r) => r.type == ARHitTestResultType.plane,
    orElse: () => results.first,
  );

  final anchor = ARPlaneAnchor(transformation: hit.worldTransform);
  final didAddAnchor = await _anchorManager.addAnchor(anchor);
  if (!didAddAnchor) return;

  final node = ARNode(
    type: NodeType.image,
    uri: _posterImagePath,        // PNG saved to temp directory
    scale: Vector3(posterWidthM, posterHeightM, 0.001),
    position: Vector3(0, 0, 0),
    rotation: Vector4(1, 0, 0, 0),
  );
  await _objectManager.addNode(node, planeAnchor: anchor);
}
```

**Texture updates when user changes theme:**

> **Performance note:** Encoding the full poster PNG and passing bytes through a Method Channel on every theme change is expensive. Instead, pre-render all 17 themes to temp PNG files at startup (or lazily), and pass only the file path when switching. The AR layer reads from disk — no byte serialization overhead.

**Things to learn:** AR hit testing, anchor lifecycle, node texture loading from file paths, real-world scale in meters.

---

### v3.3 — AR UI Overlay

**What to build:**
- Flutter widgets overlaid on top of the AR view
- Print size picker (A4, A3, A2, 24×36)
- Theme quick-switcher
- Screenshot button
- Instructions overlay ("Point at a wall, then tap to place")

```dart
Stack(
  children: [
    ARView(onARViewCreated: _onARViewCreated),  // Native AR at bottom
    if (!posterPlaced) const PlacementGuide(),  // "Tap a wall" instruction
    Positioned(
      bottom: 0,
      child: ARControlPanel(
        onSizeChanged: _updatePosterSize,
        onThemeChanged: _updateTheme,
        onCapture: _captureScreenshot,
      ),
    ),
  ],
)
```

**Things to learn:** Overlaying Flutter widgets on Platform Views, managing AR state in Riverpod, `RepaintBoundary` for AR screenshot.

---

## v4 — AR + Light Estimation + Shadows + Occlusion

**Goal:** Make the AR poster look physically present on the wall.
**Estimated effort:** 3-4 weeks

---

### v4.1 — Light Estimation

**What to build:**
- Read ambient light intensity and color temperature from AR frame
- Adjust poster material brightness/warmth to match room lighting

**Both platforms provide light estimation:**
- **ARCore:** `frame.lightEstimate.pixelIntensity` + `colorCorrection`. For higher quality, use `LightEstimationMode.ENVIRONMENTAL_HDR` (available ARCore 1.9+) which provides directional light with spherical harmonics.
- **ARKit:** `frame.lightEstimate.ambientIntensity` + `ambientColorTemperature`

**Implementation:**

```dart
// Stream light data from native via Event Channel
_lightEstimationStream.listen((data) {
  final brightness = (data['intensity'] as double) / 1000.0;
  // Convert color temperature (Kelvin) to approximate RGB tint
  final warmth = _kelvinToRgbTint(data['colorTemperature'] as double);
  // Apply as color filter on poster texture (multiply blend)
  setState(() => _posterColorFilter = ColorFilter.matrix(_buildTintMatrix(brightness, warmth)));
});
```

**Things to learn:** AR frame lifecycle, light estimation APIs, color temperature to RGB conversion.

---

### v4.2 — Virtual Shadows

**What to build:**
- Poster casts a shadow on the wall (like a real framed poster)

**Implementation:**
- Offset the poster 0.01m-0.02m from the wall surface (simulates frame depth)
- **iOS (RealityKit):** `model.components[ShadowComponent.self]` — shadow casting is built in
- **Android:** Use `ar_flutter_plugin`'s underlying renderer. If using raw ARCore + Filament, enable shadow casting on the mesh node and add a directional light matching the estimated light direction

Shadow direction should match the estimated light direction:
- ARKit provides `directionalLightEstimate` (iOS 13+)
- ARCore approximates it from `LightEstimate.colorCorrection`

**Things to learn:** 3D lighting models, shadow casting in RealityKit/Filament, directional light setup.

---

### v4.3 — People Occlusion

**What to build:**
- When a person walks between the camera and the wall poster, the poster is correctly occluded

**IMPORTANT — Device requirements (corrected):**

| Feature | iOS Requirement | Device Requirement |
|---|---|---|
| Basic person segmentation | iOS 13+ | A12 Bionic chip (iPhone XS+) |
| `personSegmentationWithDepth` | iOS 13+ | **LiDAR scanner required** (iPhone 12 Pro+, iPad Pro 2020+) |

> **Critical correction:** The original draft stated "iOS 13+" for `personSegmentationWithDepth`. This is **incorrect**. `personSegmentationWithDepth` requires a **LiDAR scanner** — available only on iPhone 12 Pro and later Pro models, and LiDAR-equipped iPad Pros. Non-LiDAR devices support `.personSegmentation` only (segmentation mask without depth precision). You must check device capability at runtime and choose the appropriate mode.

**iOS (ARKit) — capability-aware implementation:**

```swift
let config = ARWorldTrackingConfiguration()
config.planeDetectionOptions = [.vertical]

if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
  // LiDAR device — full depth-accurate occlusion
  config.frameSemantics.insert(.personSegmentationWithDepth)
} else if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentation) {
  // Non-LiDAR device — segmentation without depth
  config.frameSemantics.insert(.personSegmentation)
}
// RealityKit handles compositing automatically when frameSemantics are set
arView.session.run(config)
```

**Android (ARCore Depth API):**

```kotlin
val config = Config(session)
if (session.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
  config.depthMode = Config.DepthMode.AUTOMATIC
  // Use depth texture in shader to discard poster pixels where real depth < poster depth
}
session.configure(config)
```

Android depth support is device-specific. Many mid-range devices lack the necessary depth sensors. Always check `isDepthModeSupported()` first and degrade gracefully.

**Fallback:** On devices without depth/LiDAR support, disable occlusion silently. Users won't miss what they can't compare to.

**Things to learn:** Depth estimation, `personSegmentationWithDepth` vs `personSegmentation`, ARCore depth compositing, capability detection at runtime.

---

## Learning Roadmap Summary

### v1 — Flutter Fundamentals + Geospatial
- Flutter project architecture and Riverpod
- `freezed` + `json_serializable` code generation
- **Dart shorthands:** dot shorthand (Dart 3.10+), records as `typedef`, switch expressions, map/list/object patterns, destructuring, `if-case`, constructor tear-offs
- HTTP networking in Dart (`dio` package — `BaseOptions`, `Interceptor`, typed responses)
- Overpass QL query language and OSM data model (nodes, ways, relations)
- Multipolygon relation assembly (graph stitching problem)
- Web Mercator projection math
- Flutter `Canvas` and `CustomPainter` API
- Path batching for rendering performance
- `TextPainter` and `TextStyle.letterSpacing` for typography
- `compute()` / `Isolate` for background work
- `PictureRecorder` for off-screen rendering
- PDF generation with the `pdf` package

### v1.5 — Platform Integration
- Method Channels (Dart to Kotlin/Swift)
- Kotlin coroutines and `Dispatchers.IO`
- Android `WallpaperManager` API
- iOS App Store safe URL handling
- Device screen metrics and pixel ratios

### v2 — Gestures and Compositing
- `GestureDetector.onScaleUpdate` (unified pan + scale + rotate)
- `Matrix4` transforms
- `canvas.drawShadow()` for manual shadows
- `RepaintBoundary` for screenshot capture
- Camera/gallery permissions (Android 13+ granular permissions)

### v3 — Augmented Reality
- `ar_flutter_plugin` API (ARCore + ARKit abstraction)
- ARCore fundamentals (sessions, planes, anchors, hit tests)
- ARKit fundamentals (configurations, plane detection, raycasting)
- Flutter Platform Views (how plugins embed native views)
- Event Channels (streaming data from native to Dart)
- 3D node creation and texture loading from file paths

### v4 — Advanced AR
- AR light estimation and color correction
- Environmental HDR light estimation (ARCore)
- 3D shadow casting in RealityKit / Filament
- Depth estimation and person occlusion (LiDAR vs. non-LiDAR)
- Runtime AR capability detection and graceful degradation

---

## Testing Strategy

> **Addition:** The original Python codebase has no automated tests and this roadmap perpetuated that gap. Geospatial rendering bugs are silent — they produce a wrong-looking poster rather than a crash. Testing is not optional here.

### Unit Tests (start in v1, grow each version)

```
test/
  core/
    mercator_projection_test.dart  # All projection math — parameterized with known outputs
    road_classifier_test.dart      # Highway tag → RoadType mapping
    overpass_parser_test.dart      # JSON fixture → MapData, including multipolygon assembly
    rate_limiter_test.dart         # Verify sequential request queuing
    theme_loader_test.dart         # Missing key validation, hex color parsing
  features/
    geocoding_service_test.dart    # Mock HTTP, test cache hit/miss
```

### Widget Tests

```
test/
  features/
    poster_painter_test.dart       # Golden tests for each of the 17 themes
    export_test.dart               # Verify PNG byte output is non-empty and valid
```

> **Golden tests** are especially valuable here — render the poster to a PNG and compare to a stored reference image. Any regression in rendering immediately produces a diff.

### Integration Tests

```
integration_test/
  poster_generation_test.dart      # City search → render → export full flow (uses mock Overpass)
```

---

## External APIs and Rate Limits Reference

| API | Endpoint | Rate Limit | Auth |
|---|---|---|---|
| Nominatim | `nominatim.openstreetmap.org/search` | 1 req/sec, no bulk | No key |
| Overpass | `overpass-api.de/api/interpreter` | Best-effort, throttled by server load | No key |
| Google Fonts | `fonts.googleapis.com/css2` | No limit | No key |

For a production app beyond ~1K users, plan to self-host Nominatim/Overpass or switch to a paid geocoding provider (Mapbox, LocationIQ).

**Memory limits — Overpass response size:**

Large cities (15-20km radius) can return 10-100 MB of JSON. Keep in mind:
- Android: 512 MB typical app memory limit; aggressive GC
- iOS: Lower tolerance — OS kills processes aggressively above ~200 MB
- Always parse in an isolate (`compute()`), and consider streaming JSON parse for very large cities

---

## Cost Breakdown

### Development and Small User Base (< 1K users)

| Item | Cost |
|---|---|
| All APIs (Nominatim, Overpass, Google Fonts) | $0 |
| Flutter + all packages | $0 |
| Apple Developer Account | $99/year |
| Google Play Account | $25 one-time |
| **Total Year 1** | **~$124** |

### Production App (10K+ users)

| Item | Cost/month |
|---|---|
| Geocoding (self-hosted or paid API) | $20-100 |
| OSM data (self-hosted Overpass or pre-processed tiles) | $50-200 |
| Backend server (user accounts, cloud cache) | $20-100 |
| Apple Developer | ~$8 (annualized) |
| **Total** | **~$100-400/mo** |

---

## Checklist

### v1 — Generate Poster + Export PNG/PDF
- [ ] v1.0 — Upfront: set `minSdkVersion 24`, iOS deployment target 13.0, add all permissions to manifests
- [x] v1.1 — Project setup: Flutter project, folder structure, pubspec.yaml, Riverpod, `flutter_lints`, `freezed`, `dio`, `AppColors`/`AppStyles` design system
- [x] v1.2 — Domain models: `MapTheme` (with `id`, `ColorConverter`, validation), `CityCoordinates`, `RoadSegment`, `MapFeature`, `MapData` — all as `abstract class` (freezed 3.x)
- [x] v1.3 — Geocoding service: Nominatim HTTP, sequential `RateLimiter`, Hive caching
- [x] v1.4 — Overpass API: query builder with `compensatedDist`, response parser (nodes/ways/relations + multipolygon assembly), background `compute()` parsing
- [x] v1.5 — Mercator projection: lat/lon to screen coords, bounding box, aspect ratio crop
- [ ] v1.6 — Rendering engine: `CustomPainter` with all 6 layers, **path batching for roads**, `TextStyle.letterSpacing`, `Color.withValues()`
- [ ] v1.7 — Export system: PNG via `PictureRecorder` with OOM guard, PDF via `pdf` package, gallery save via `gal`, share
- [ ] v1.8 — UI screens: home (`SearchBar`/`SearchAnchor`), poster preview, theme browser, export sheet
- [ ] v1.9 — Tests: projection unit tests, golden tests for themes, Overpass parser tests

### v1.5 — Mobile Wallpaper Application
- [ ] v1.5.1 — Screen-aware rendering: device resolution detection, wallpaper layout adjustments
- [ ] v1.5.2 — Wallpaper setting: Android `WallpaperManager` on `Dispatchers.IO`, iOS save + App-Store-safe guidance
- [ ] v1.5.3 — Wallpaper UI: `ClipRRect` phone frame mockup, home/lock toggle, theme suggestions

### v2 — 2D Wall Mockup
- [ ] v2.1 — Image picker: camera capture, gallery selection (Android 13+ permissions)
- [ ] v2.2 — Interactive placement: `onScaleUpdate` for unified pan/scale/rotate, `canvas.drawShadow()`, perspective warp (if in scope)
- [ ] v2.3 — Composite export: `RepaintBoundary` capture, share mockup

### v3 — AR Wall Preview
- [ ] v3.1 — AR foundation: `ar_flutter_plugin` setup, ARCore/ARKit sessions, vertical plane detection, device capability check + fallback
- [ ] v3.2 — AR poster placement: hit test, anchors, real-world sizing (meters), texture loading from file paths
- [ ] v3.3 — AR UI overlay: size picker, theme switcher (file-path-based), screenshot, instructions

### v4 — AR + Light Estimation + Shadows + Occlusion
- [ ] v4.1 — Light estimation: ambient intensity, color temperature, poster tint via `ColorFilter`
- [ ] v4.2 — Virtual shadows: 0.01-0.02m wall offset, RealityKit `ShadowComponent` (iOS), Filament shadow (Android)
- [ ] v4.3 — People occlusion: runtime LiDAR check, `personSegmentationWithDepth` vs `personSegmentation` (iOS), ARCore Depth API (Android), graceful fallback
