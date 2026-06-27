import 'dart:convert';

import 'package:maposter/src/cache/cache_store.dart';
import 'package:maposter/src/datasources/local/nominatim_local_datasource.dart';
import 'package:maposter/src/entities/city_coordinates.dart';

class NominatimLocalDatasourceImpl implements NominatimLocalDatasource {
  NominatimLocalDatasourceImpl(this._cache);

  final CacheStore _cache;

  @override
  Future<CityCoordinates?> get(String key) async {
    final raw = await _cache.read(key);
    if (raw == null) return null;
    final cached = jsonDecode(raw) as Map<String, dynamic>;
    return CityCoordinates(
      latitude: cached['latitude'] as double,
      longitude: cached['longitude'] as double,
      displayName: cached['displayName'] as String,
      city: cached['city'] as String?,
      country: cached['country'] as String?,
    );
  }

  @override
  Future<void> put(String key, CityCoordinates coordinates) => _cache.write(
    key,
    jsonEncode({
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'displayName': coordinates.displayName,
      'city': coordinates.city,
      'country': coordinates.country,
    }),
  );
}
