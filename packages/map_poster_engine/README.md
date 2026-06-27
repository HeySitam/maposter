# map_poster_engine

Turn a city name into a minimalist OpenStreetMap poster: geocoding, Overpass map
data, Mercator projection, `CustomPainter` rendering, and PNG/PDF export.

Framework-agnostic (no state-management dependency) with pluggable caching.

## Usage

```dart
import 'package:flutter/widgets.dart';
import 'package:map_poster_engine/map_poster_engine.dart';

final engine = MapPosterEngine(
  // userAgent is REQUIRED — OpenStreetMap Nominatim's policy needs a real,
  // identifying agent (app name + contact).
  const MapPosterEngineConfig(userAgent: 'myapp/1.0 (com.example.myapp)'),
);

final coords = await engine.geocode('Kolkata', 'India');
final data = await engine.fetchMapData((coords.latitude, coords.longitude));
final theme = await engine.getTheme('noir');

final painter = engine.buildPainter(
  mapData: data,
  theme: theme,
  cityName: 'Kolkata',
  countryName: 'India',
  latitude: coords.latitude,
  longitude: coords.longitude,
);

// Render in a widget tree: CustomPaint(painter: painter)
// Or export:
final png = await engine.exportPng(painter, const Size(1200, 1600));
final pdf = await engine.exportPdf(png, const Size(1200, 1600));
```

## Caching

The engine caches geocoding and map-data results through a `CacheStore`. The
default is `InMemoryCacheStore` (process-lifetime). Supply your own for
persistence:

```dart
class MyCacheStore implements CacheStore {
  @override
  Future<String?> read(String key) async => /* ... */;
  @override
  Future<void> write(String key, String value) async => /* ... */;
}

final engine = MapPosterEngine(config, cache: MyCacheStore());
```

## Themes

17 themes ship with the package. Add your own in code — they merge with the
built-ins (a custom theme reusing a built-in `id` overrides it):

```dart
final engine = MapPosterEngine(
  config,
  customThemes: [
    MapTheme.fromHex(
      id: 'brand',
      name: 'Brand',
      bg: '#0A0A0A',
      text: '#E0FF00',
      gradientColor: '#0A0A0A',
      water: '#111111',
      parks: '#1A1A1A',
      roadMotorway: '#E0FF00',
      roadPrimary: '#C8E000',
      roadSecondary: '#96A800',
      roadTertiary: '#647000',
      roadResidential: '#323800',
      roadDefault: '#647000',
    ),
  ],
);
```
