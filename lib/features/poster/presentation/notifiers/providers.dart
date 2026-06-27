import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:map_poster_engine/map_poster_engine.dart';
import 'package:map_to_poster/core/cache/hive_cache_store.dart';
import 'package:map_to_poster/core/constants/app_constants.dart';

// ── Engine ───────────────────────────────────────────────────────────────────

final mapPosterEngineProvider = Provider<MapPosterEngine>(
  (_) => MapPosterEngine(
    const MapPosterEngineConfig(userAgent: AppConstants.userAgent),
    cache: HiveCacheStore(Hive.box<dynamic>(AppConstants.cacheBoxName)),
  ),
);

// ── Themes ───────────────────────────────────────────────────────────────────

final allThemesProvider = FutureProvider<List<MapTheme>>(
  (ref) => ref.watch(mapPosterEngineProvider).getAllThemes(),
);

final selectedThemeIdProvider = StateProvider<String>((_) => 'noir');

final selectedThemeProvider = FutureProvider<MapTheme>((ref) {
  final id = ref.watch(selectedThemeIdProvider);
  return ref.watch(mapPosterEngineProvider).getTheme(id);
});

// ── Data fetching ────────────────────────────────────────────────────────────

final geocodingProvider =
    FutureProvider.family<CityCoordinates, ({String city, String country})>(
  (ref, args) =>
      ref.watch(mapPosterEngineProvider).geocode(args.city, args.country),
);

final mapDataProvider =
    FutureProvider.family<MapData, ({LatLon center, double radiusMeters})>(
  (ref, args) => ref.watch(mapPosterEngineProvider).fetchMapData(
        args.center,
        radiusMeters: args.radiusMeters,
      ),
);
