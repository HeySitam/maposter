import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:map_to_poster/core/constants/app_constants.dart';
import 'package:map_to_poster/core/network/dio_client.dart';
import 'package:map_to_poster/core/network/rate_limiter.dart';
import 'package:map_to_poster/features/poster/data/datasources/local/nominatim_local_datasource.dart';
import 'package:map_to_poster/features/poster/data/datasources/local/nominatim_local_datasource_impl.dart';
import 'package:map_to_poster/features/poster/data/datasources/local/theme_local_datasource.dart';
import 'package:map_to_poster/features/poster/data/datasources/local/theme_local_datasource_impl.dart';
import 'package:map_to_poster/features/poster/data/datasources/remote/nominatim_remote_datasource.dart';
import 'package:map_to_poster/features/poster/data/datasources/remote/nominatim_remote_datasource_impl.dart';
import 'package:map_to_poster/features/poster/data/repositories/geocoding_repository_impl.dart';
import 'package:map_to_poster/features/poster/data/repositories/theme_repository_impl.dart';
import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';
import 'package:map_to_poster/features/poster/domain/entities/map_theme.dart';
import 'package:map_to_poster/features/poster/domain/repositories/geocoding_repository.dart';
import 'package:map_to_poster/features/poster/domain/repositories/theme_repository.dart';

// ── Network ──────────────────────────────────────────────────────────────────

final nominatimDioProvider = Provider((_) => buildNominatimDio());

final rateLimiterProvider = Provider(
  (_) => RateLimiter(
    minGap: const Duration(milliseconds: AppConstants.nominatimRateLimitMs),
  ),
);

// ── Cache ──────────────────────────────────────────────────────────────────────

final geocodingCacheBoxProvider = Provider<Box<dynamic>>(
  (_) => Hive.box<dynamic>(AppConstants.geocodingCacheBoxName),
);

// ── Data sources ──────────────────────────────────────────────────────────────

final nominatimRemoteDatasourceProvider = Provider<NominatimRemoteDatasource>(
  (ref) => NominatimRemoteDatasourceImpl(
    ref.watch(nominatimDioProvider),
    ref.watch(rateLimiterProvider),
  ),
);

final nominatimLocalDatasourceProvider = Provider<NominatimLocalDatasource>(
  (ref) => NominatimLocalDatasourceImpl(ref.watch(geocodingCacheBoxProvider)),
);

final themeLocalDatasourceProvider = Provider<ThemeLocalDatasource>(
  (_) => ThemeLocalDatasourceImpl(),
);

// ── Repositories ──────────────────────────────────────────────────────────────

final geocodingRepositoryProvider = Provider<GeocodingRepository>(
  (ref) => GeocodingRepositoryImpl(
    ref.watch(nominatimRemoteDatasourceProvider),
    ref.watch(nominatimLocalDatasourceProvider),
  ),
);

final themeRepositoryProvider = Provider<ThemeRepository>(
  (ref) => ThemeRepositoryImpl(ref.watch(themeLocalDatasourceProvider)),
);

// ── Feature providers ──────────────────────────────────────────────────────────

final allThemesProvider = FutureProvider<List<MapTheme>>(
  (ref) => ref.watch(themeRepositoryProvider).getAllThemes(),
);

final selectedThemeIdProvider = StateProvider<String>((_) => 'noir');

final selectedThemeProvider = FutureProvider<MapTheme>((ref) {
  final id = ref.watch(selectedThemeIdProvider);
  return ref.watch(themeRepositoryProvider).getTheme(id);
});

final geocodingProvider =
    FutureProvider.family<CityCoordinates, ({String city, String country})>(
  (ref, args) => ref
      .watch(geocodingRepositoryProvider)
      .getCoordinates(args.city, args.country),
);
