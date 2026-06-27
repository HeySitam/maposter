# 🗺️ maposter

[![pub package](https://img.shields.io/pub/v/maposter.svg)](https://pub.dev/packages/maposter)
[![pub points](https://img.shields.io/pub/points/maposter)](https://pub.dev/packages/maposter/score)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> Turn any city in the world into a beautiful, minimalist map poster — straight from OpenStreetMap data.

**maposter** is a framework-agnostic Flutter package that takes a city name and produces a print-ready map poster. It geocodes the place, pulls roads, water and parks from OpenStreetMap, projects them with Web Mercator, renders them onto a `Canvas`, and exports to high-resolution **PNG** or **PDF**. Seventeen hand-tuned themes are bundled — and you can add your own in a single line.

No state-management or storage dependency is forced on you, and caching is fully pluggable.

<!-- Tip: drop a sample poster image here (e.g. docs/sample.png) for a stronger pub.dev page. -->

---

## ✨ Features

- 🌍 **Geocoding** — city + country → coordinates via OpenStreetMap Nominatim, rate-limited per policy.
- 🛣️ **Map data** — roads, water bodies and parks fetched from the Overpass API and parsed off the main thread in an isolate.
- 📐 **Web Mercator projection** — accurate lat/lon → screen math, with aspect-ratio-aware framing.
- 🎨 **17 bundled themes** — from `noir` to `neon_cyberpunk` — plus first-class **custom themes**.
- 🖼️ **Canvas rendering** — a ready-to-use `CustomPainter` you can drop into any widget tree.
- 📤 **PNG & PDF export** — print-ready output at configurable DPI, with a built-in memory guard.
- 🧩 **Framework-agnostic** — plain Dart API + a single `MaposterEngine` facade. Works with Riverpod, BLoC, Provider, or nothing at all.
- 💾 **Pluggable caching** — ships with an in-memory cache; bring your own (Hive, sqflite, files…) via one interface.
- 🛑 **Cancellable requests** — pass a `CancelToken` to abort in-flight map fetches.
- 🖥️ **Every platform** — Android, iOS, web, macOS, Windows and Linux.

---

## 📦 Installation

```bash
flutter pub add maposter
```

Or add it to your `pubspec.yaml`:

```yaml
dependencies:
  maposter: ^0.1.2
```

---

## 🚀 Quick start

```dart
import 'package:flutter/widgets.dart';
import 'package:maposter/maposter.dart';

final engine = MaposterEngine(
  // userAgent is REQUIRED — OpenStreetMap's Nominatim policy needs a real,
  // identifying agent (your app name + a contact).
  const MaposterConfig(userAgent: 'myapp/1.0 (com.example.myapp)'),
);

// 1. City name → coordinates
final coords = await engine.geocode('Kolkata', 'India');

// 2. Coordinates → map geometry (roads, water, parks)
final data = await engine.fetchMapData((coords.latitude, coords.longitude));

// 3. Pick a theme
final theme = await engine.getTheme('noir');

// 4. Build the painter
final painter = engine.buildPainter(
  mapData: data,
  theme: theme,
  cityName: 'Kolkata',
  countryName: 'India',
  latitude: coords.latitude,
  longitude: coords.longitude,
);

// 5a. Render it live in a widget tree:
//     CustomPaint(painter: painter)

// 5b. …or export it:
final png = await engine.exportPng(painter, const Size(1200, 1600));
final pdf = await engine.exportPdf(png, const Size(1200, 1600));
```

---

## 🧭 Step by step

### Configure the engine

`MaposterConfig` carries everything the engine needs to talk to OpenStreetMap. Only `userAgent` is required:

```dart
final engine = MaposterEngine(
  const MaposterConfig(
    userAgent: 'myapp/1.0 (com.example.myapp)',
    defaultRadiusMeters: 18000, // how much of the city to capture
  ),
);
```

### Geocode a place

```dart
final coords = await engine.geocode('Paris', 'France');
print('${coords.displayName} @ ${coords.latitude}, ${coords.longitude}');
```

### Fetch map data

```dart
final data = await engine.fetchMapData(
  (coords.latitude, coords.longitude),
  radiusMeters: 20000, // optional; defaults to config.defaultRadiusMeters
);
print('${data.roads.length} roads, '
      '${data.waterFeatures.length} water, '
      '${data.parkFeatures.length} parks');
```

### Render & export

`buildPainter` returns a `MaposterPainter` (a `CustomPainter`). Render it live with `CustomPaint`, or rasterize it:

```dart
// 3× scale ≈ 300 DPI for a 1200×1600 poster
final png = await engine.exportPng(painter, const Size(1200, 1600), scale: 3.0);
final pdf = await engine.exportPdf(png, const Size(1200, 1600));
```

---

## 🎨 Themes

Seventeen themes ship with the package:

| | | | |
|---|---|---|---|
| `noir` | `blueprint` | `autumn` | `emerald` |
| `forest` | `ocean` | `sunset` | `terracotta` |
| `warm_beige` | `midnight_blue` | `monochrome_blue` | `neon_cyberpunk` |
| `japanese_ink` | `pastel_dream` | `copper_patina` | `gradient_roads` |
| `contrast_zones` | | | |

```dart
final all = await engine.getAllThemes(); // List<MapTheme>
final noir = await engine.getTheme('noir');
```

### Custom themes

Define your own in code with hex strings — they merge with the built-ins. Reuse a built-in `id` to override it:

```dart
final engine = MaposterEngine(
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

final mine = await engine.getTheme('brand'); // your theme
```

---

## 💾 Caching

The engine caches geocoding and map-data results through a `CacheStore`. By default it uses an in-memory cache (`InMemoryCacheStore`) that lasts for the life of the process. Provide your own to persist results across launches and avoid re-hitting the network:

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maposter/maposter.dart';

class HiveCacheStore implements CacheStore {
  HiveCacheStore(this._box);
  final Box<dynamic> _box;

  @override
  Future<String?> read(String key) async => _box.get(key) as String?;

  @override
  Future<void> write(String key, String value) => _box.put(key, value);
}

// …after opening the box:
final engine = MaposterEngine(config, cache: HiveCacheStore(myBox));
```

Want to disable caching entirely? Use `NoopCacheStore()`.

---

## ⚙️ Configuration reference

`MaposterConfig` options:

| Option | Default | Description |
|---|---|---|
| `userAgent` | **required** | Identifying UA sent to Nominatim (its policy requires a real one). |
| `defaultRadiusMeters` | `18000` | Default capture radius when none is passed to `fetchMapData`. |
| `nominatimBaseUrl` | `https://nominatim.openstreetmap.org` | Geocoding endpoint. |
| `overpassBaseUrl` | `https://overpass-api.de/api/interpreter` | Map-data endpoint. |
| `nominatimMinGap` | `1100 ms` | Minimum gap between geocoding requests. |
| `overpassMinGap` | `2 s` | Minimum gap between Overpass requests. |
| `connectTimeout` | `30 s` | Connection timeout. |
| `receiveTimeout` | `30 s` | Receive timeout (Nominatim). |
| `overpassReceiveTimeout` | `60 s` | Receive timeout for Overpass (queries can be slow). |

---

## 🛑 Cancellation

`fetchMapData` accepts a `CancelToken` (re-exported from `dio`) so you can abort an in-flight request — e.g. when the user starts a new search:

```dart
final token = CancelToken();
final future = engine.fetchMapData(center, token: token);
// …later:
token.cancel();
```

---

## 🧯 Error handling

The engine throws a sealed `AppException`. Switch over its subtypes for precise handling, or just show `message`:

```dart
try {
  final coords = await engine.geocode(city, country);
} on GeocodingException catch (e) {
  // no match for that place
} on NetworkException catch (e) {
  // e.statusCode is available
} on AppException catch (e) {
  showError(e.message);
}
```

Subtypes: `NetworkException`, `GeocodingException`, `OverpassException`, `CacheException`, `RenderException`, `AssetException`.

---

## 🖥️ Platform support

| Android | iOS | Web | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## 📱 Example app

A complete demo app — city input, theme picker, live preview and an export sheet (save to gallery / share PNG / share PDF) — lives in [`example/`](example). It shows how to wire `maposter` into a real app (here with Riverpod + Hive-backed caching).

---

## 🗺️ Attribution & usage policy

Map data is © OpenStreetMap contributors, available under the [Open Database License (ODbL)](https://www.openstreetmap.org/copyright). The painter already renders an **“© OpenStreetMap contributors”** credit onto every poster — please keep it visible.

This package calls the public [Nominatim](https://operations.osmfoundation.org/policies/nominatim/) and [Overpass](https://dev.overpass-api.de/overpass-doc/en/preface/design.html) endpoints, which enforce usage policies (rate limits and a required, identifying `User-Agent`). Always set a real `userAgent` in `MaposterConfig`. For heavy or production traffic, point `nominatimBaseUrl` / `overpassBaseUrl` at your own hosted instances.

---

## 🤝 Contributing

Issues and pull requests are welcome over on [GitHub](https://github.com/HeySitam/maposter). If you build something with maposter, I'd love to see it!

## 📄 License

[MIT](LICENSE) © Sitam Sardar
