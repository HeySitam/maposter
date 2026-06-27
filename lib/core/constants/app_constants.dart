abstract final class AppConstants {
  /// Identifying User-Agent for the engine (required by Nominatim's policy).
  static const String userAgent = 'maptoposter-mobile/1.0 (dev.heysitam.map_to_poster)';

  /// Single Hive box backing the engine's [HiveCacheStore].
  static const String cacheBoxName = 'map_poster_cache';
}
