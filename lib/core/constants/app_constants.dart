abstract final class AppConstants {
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const String overpassBaseUrl = 'https://overpass-api.de/api/interpreter';
  static const String userAgent = 'maptoposter-mobile/1.0 (dev.heysitam.map_to_poster)';

  static const double defaultRadiusMeters = 18000;
  static const int nominatimRateLimitMs = 1100;
  static const int networkTimeoutSeconds = 30;

  static const String themesAssetPath = 'assets/themes/';
  static const String postersDir = 'map_to_poster/posters';
}
