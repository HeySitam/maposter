import 'package:maposter/src/entities/city_coordinates.dart';

abstract interface class NominatimRemoteDatasource {
  Future<CityCoordinates> searchCity(String city, String country);
}
