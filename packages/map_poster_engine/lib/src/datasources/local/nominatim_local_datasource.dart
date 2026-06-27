import 'package:map_poster_engine/src/entities/city_coordinates.dart';

abstract interface class NominatimLocalDatasource {
  Future<CityCoordinates?> get(String key);
  Future<void> put(String key, CityCoordinates coordinates);
}
