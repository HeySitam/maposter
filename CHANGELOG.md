## 0.1.1

- Widen the `google_fonts` constraint to `>=6.2.1 <9.0.0` so newer setups can
  resolve the latest release (improves the pub.dev "up-to-date dependencies"
  score). Older-Flutter consumers can still use 6.x.

## 0.1.0

- Initial release. Extracted the map-creation engine from the `map_to_poster`
  app: geocoding (Nominatim), map data (Overpass), Mercator projection,
  `MaposterPainter` rendering, and PNG/PDF export.
- Framework-agnostic: no state-management or storage dependency.
- Pluggable caching via `CacheStore` (defaults to in-memory).
- 17 bundled themes; custom themes via `MapTheme.fromHex` + `customThemes`.
