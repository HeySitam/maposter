import 'package:map_poster_engine/src/entities/city_coordinates.dart';

abstract interface class GeocodingRepository {
  Future<CityCoordinates> getCoordinates(String city, String country);
}
