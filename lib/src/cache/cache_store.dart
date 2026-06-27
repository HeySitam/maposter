/// Pluggable key/value cache for geocoding and map-data results.
///
/// Keys are already globally namespaced by the engine (e.g.
/// `geocoding_paris_france`, `48.8566_2.3522_3000_roads`), and values are
/// JSON strings — implementations only deal in `String`s, never domain types.
///
/// The engine defaults to [InMemoryCacheStore]. Apps can supply a persistent
/// implementation (e.g. backed by Hive, sqflite, or a file).
abstract interface class CacheStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

/// Default store: caches for the lifetime of the process, in memory.
class InMemoryCacheStore implements CacheStore {
  final Map<String, String> _map = {};

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> write(String key, String value) async => _map[key] = value;
}

/// Disables caching entirely — every read misses.
class NoopCacheStore implements CacheStore {
  const NoopCacheStore();

  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}
