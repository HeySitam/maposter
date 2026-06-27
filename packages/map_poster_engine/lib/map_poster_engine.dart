/// Turn a city name into a minimalist OpenStreetMap poster.
///
/// Geocoding, Overpass map data, Mercator projection, CustomPainter rendering,
/// and PNG/PDF export — framework-agnostic, with pluggable caching.
library;

// Re-export dio cancellation symbols so consumers don't need a direct dio dep.
export 'package:dio/dio.dart' show CancelToken, DioException, DioExceptionType;

export 'src/cache/cache_store.dart'
    show CacheStore, InMemoryCacheStore, NoopCacheStore;
export 'src/config/map_poster_engine_config.dart';
export 'src/entities/city_coordinates.dart';
export 'src/entities/map_data.dart'
    show MapData, RoadSegment, MapFeature, RoadType, FeatureType;
export 'src/entities/map_theme.dart' show MapTheme;
export 'src/errors/app_exception.dart';
export 'src/map_poster_engine_base.dart' show MapPosterEngine;
export 'src/painters/map_poster_painter.dart' show MapPosterPainter;
export 'src/repositories/geocoding_repository.dart' show GeocodingRepository;
export 'src/repositories/map_data_repository.dart' show MapDataRepository;
export 'src/repositories/theme_repository.dart' show ThemeRepository;
export 'src/services/poster_exporter.dart' show PosterExporter;
export 'src/utils/mercator.dart' show Mercator, LatLon, LatLonBounds;
