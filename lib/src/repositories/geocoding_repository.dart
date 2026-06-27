import 'package:maposter/src/entities/city_coordinates.dart';

abstract interface class GeocodingRepository {
  Future<CityCoordinates> getCoordinates(String city, String country);
}
