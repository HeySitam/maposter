import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:maposter/src/cache/cache_store.dart';
import 'package:maposter/src/config/maposter_config.dart';
import 'package:maposter/src/datasources/local/nominatim_local_datasource_impl.dart';
import 'package:maposter/src/datasources/local/overpass_local_datasource_impl.dart';
import 'package:maposter/src/datasources/local/theme_local_datasource_impl.dart';
import 'package:maposter/src/datasources/remote/nominatim_remote_datasource_impl.dart';
import 'package:maposter/src/datasources/remote/overpass_remote_datasource_impl.dart';
import 'package:maposter/src/entities/city_coordinates.dart';
import 'package:maposter/src/entities/map_data.dart';
import 'package:maposter/src/entities/map_data_progress.dart';
import 'package:maposter/src/entities/map_theme.dart';
import 'package:maposter/src/network/dio_client.dart';
import 'package:maposter/src/network/rate_limiter.dart';
import 'package:maposter/src/painters/maposter_painter.dart';
import 'package:maposter/src/repositories/geocoding_repository.dart';
import 'package:maposter/src/repositories/geocoding_repository_impl.dart';
import 'package:maposter/src/repositories/map_data_repository.dart';
import 'package:maposter/src/repositories/map_data_repository_impl.dart';
import 'package:maposter/src/repositories/theme_repository.dart';
import 'package:maposter/src/repositories/theme_repository_impl.dart';
import 'package:maposter/src/services/poster_exporter.dart';
import 'package:maposter/src/utils/mercator.dart';

/// Entry point for the map-poster engine.
///
/// Turns a city name into a finished poster: geocoding, OpenStreetMap data
/// fetching, Mercator projection, rendering, and PNG/PDF export.
///
/// ```dart
/// final engine = MaposterEngine(
///   const MaposterConfig(userAgent: 'myapp/1.0 (com.example.myapp)'),
/// );
/// final coords = await engine.geocode('Kolkata', 'India');
/// final data = await engine.fetchMapData((coords.latitude, coords.longitude));
/// final theme = await engine.getTheme('noir');
/// final painter = engine.buildPainter(
///   mapData: data, theme: theme,
///   cityName: 'Kolkata', countryName: 'India',
///   latitude: coords.latitude, longitude: coords.longitude,
/// );
/// final png = await engine.exportPng(painter, const Size(1200, 1600));
/// ```
class MaposterEngine {
  MaposterEngine(
    this.config, {
    CacheStore? cache,
    List<MapTheme> customThemes = const [],
  }) : _cache = cache ?? InMemoryCacheStore() {
    final nominatimDio = buildNominatimDio(config);
    final overpassDio = buildOverpassDio(config);
    final nominatimRateLimiter = RateLimiter(minGap: config.nominatimMinGap);
    final overpassRateLimiter = RateLimiter(minGap: config.overpassMinGap);

    _geocoding = GeocodingRepositoryImpl(
      NominatimRemoteDatasourceImpl(nominatimDio, nominatimRateLimiter),
      NominatimLocalDatasourceImpl(_cache),
    );
    _mapData = MapDataRepositoryImpl(
      OverpassRemoteDatasourceImpl(overpassDio, overpassRateLimiter),
      OverpassLocalDatasourceImpl(_cache),
    );
    _themes = ThemeRepositoryImpl(
      ThemeLocalDatasourceImpl(),
      customThemes: customThemes,
    );
  }

  final MaposterConfig config;
  final CacheStore _cache;

  late final GeocodingRepository _geocoding;
  late final MapDataRepository _mapData;
  late final ThemeRepository _themes;
  final PosterExporter _exporter = const PosterExporter();

  /// The repositories, exposed for advanced wiring/testing. Most callers
  /// should use the convenience methods below.
  GeocodingRepository get geocodingRepository => _geocoding;
  MapDataRepository get mapDataRepository => _mapData;
  ThemeRepository get themeRepository => _themes;

  // ── Geocoding ──────────────────────────────────────────────────────────────

  Future<CityCoordinates> geocode(String city, String country) =>
      _geocoding.getCoordinates(city, country);

  // ── Map data ───────────────────────────────────────────────────────────────

  Future<MapData> fetchMapData(
    LatLon center, {
    double? radiusMeters,
    CancelToken? token,
    MapDataProgressCallback? onProgress,
  }) => _mapData.fetchMapData(
    center,
    radiusMeters ?? config.defaultRadiusMeters,
    token: token,
    onProgress: onProgress,
  );

  // ── Themes ───────────────────────────────────────────────────────────────────

  Future<List<MapTheme>> getAllThemes() => _themes.getAllThemes();
  Future<MapTheme> getTheme(String id) => _themes.getTheme(id);

  // ── Rendering ──────────────────────────────────────────────────────────────

  MaposterPainter buildPainter({
    required MapData mapData,
    required MapTheme theme,
    required String cityName,
    required String countryName,
    required double latitude,
    required double longitude,
  }) => MaposterPainter(
    mapData: mapData,
    theme: theme,
    cityName: cityName,
    countryName: countryName,
    latitude: latitude,
    longitude: longitude,
  );

  // ── Export ──────────────────────────────────────────────────────────────────

  Future<Uint8List> exportPng(
    MaposterPainter painter,
    Size posterSize, {
    double scale = 3.0,
  }) => _exporter.exportPng(painter, posterSize, scale: scale);

  Future<Uint8List> exportPdf(Uint8List png, Size posterSize) =>
      _exporter.exportPdf(png, posterSize);
}
