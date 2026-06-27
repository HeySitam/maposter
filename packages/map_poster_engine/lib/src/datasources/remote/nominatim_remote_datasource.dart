import 'package:map_poster_engine/src/entities/city_coordinates.dart';

abstract interface class NominatimRemoteDatasource {
  Future<CityCoordinates> searchCity(String city, String country);
}
