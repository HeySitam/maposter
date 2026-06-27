## 0.1.0

- Initial release. Extracted the map-creation engine from the `map_to_poster`
  app: geocoding (Nominatim), map data (Overpass), Mercator projection,
  `MaposterPainter` rendering, and PNG/PDF export.
- Framework-agnostic: no state-management or storage dependency.
- Pluggable caching via `CacheStore` (defaults to in-memory).
- 17 bundled themes; custom themes via `MapTheme.fromHex` + `customThemes`.
