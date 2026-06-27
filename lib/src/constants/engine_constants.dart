/// Package-internal constants tied to the package's own layout.
///
/// User-overridable values (endpoints, user agent, timeouts, default radius,
/// rate limits) live on [MaposterConfig] instead.
abstract final class EngineConstants {
  /// Path to the bundled theme JSON files. Uses the `packages/<pkg>/` prefix
  /// so `rootBundle` resolves them from any consuming app.
  static const String themesAssetPath = 'packages/maposter/assets/themes/';

  /// Ids of the theme JSON files bundled under [themesAssetPath].
  static const List<String> bundledThemeIds = [
    'autumn',
    'blueprint',
    'contrast_zones',
    'copper_patina',
    'emerald',
    'forest',
    'gradient_roads',
    'japanese_ink',
    'midnight_blue',
    'monochrome_blue',
    'neon_cyberpunk',
    'noir',
    'ocean',
    'pastel_dream',
    'sunset',
    'terracotta',
    'warm_beige',
  ];
}
