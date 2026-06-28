## 0.2.0

- Add an optional `onProgress` callback to `MaposterEngine.fetchMapData`
  (and the underlying repository), reporting each Overpass stage
  (roads → water → parks) as it begins, with a `fromCache` flag. Lets apps
  show staged progress during the slow first-time fetch of a city. New exports:
  `MapDataProgress`, `MapDataStage`, `MapDataProgressCallback`.
- Example: the demo now shows a labeled progress bar with per-stage status and
  an elapsed timer instead of a bare spinner.
- Example: replace the free-text City/Country fields with cascading, searchable
  Country → State → City dropdowns backed by the offline `country_state_city`
  package, so every selection geocodes cleanly.

## 0.1.2

- Docs: use a version-less install snippet in the README so it never goes stale.

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
