import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';

abstract interface class GeocodingRepository {
  Future<CityCoordinates> getCoordinates(String city, String country);
}
