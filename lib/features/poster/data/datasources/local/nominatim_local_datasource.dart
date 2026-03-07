import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';

abstract interface class NominatimLocalDatasource {
  CityCoordinates? get(String key);
  Future<void> put(String key, CityCoordinates coordinates);
}
