import 'package:hive_flutter/hive_flutter.dart';
import 'package:map_to_poster/features/poster/data/datasources/local/nominatim_local_datasource.dart';
import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';

class NominatimLocalDatasourceImpl implements NominatimLocalDatasource {
  NominatimLocalDatasourceImpl(this._box);

  final Box<dynamic> _box;

  @override
  CityCoordinates? get(String key) {
    final cached = _box.get(key) as Map?;
    if (cached == null) return null;
    return CityCoordinates(
      latitude: cached['latitude'] as double,
      longitude: cached['longitude'] as double,
      displayName: cached['displayName'] as String,
      city: cached['city'] as String?,
      country: cached['country'] as String?,
    );
  }

  @override
  Future<void> put(String key, CityCoordinates coordinates) => _box.put(key, {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
        'displayName': coordinates.displayName,
        'city': coordinates.city,
        'country': coordinates.country,
      });
}
