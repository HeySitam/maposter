import 'package:hive_flutter/hive_flutter.dart';
import 'package:map_poster_engine/map_poster_engine.dart';

/// Hive-backed [CacheStore] for the engine's geocoding and map-data caches.
class HiveCacheStore implements CacheStore {
  HiveCacheStore(this._box);

  final Box<dynamic> _box;

  @override
  Future<String?> read(String key) async => _box.get(key) as String?;

  @override
  Future<void> write(String key, String value) => _box.put(key, value);
}
