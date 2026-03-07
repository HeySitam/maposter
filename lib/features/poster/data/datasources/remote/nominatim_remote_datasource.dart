import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';

abstract interface class NominatimRemoteDatasource {
  Future<CityCoordinates> searchCity(String city, String country);
}
