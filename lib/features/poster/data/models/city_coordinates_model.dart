import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';

class CityCoordinatesModel extends CityCoordinates {
  const CityCoordinatesModel({
    required super.city,
    required super.country,
    required super.latLon,
    super.displayCity,
    super.displayCountry,
  });

  factory CityCoordinatesModel.fromNominatim(
    Map<String, dynamic> json, {
    required String city,
    required String country,
  }) {
    final lat = double.parse(json['lat'] as String);
    final lon = double.parse(json['lon'] as String);
    return CityCoordinatesModel(
      city: city,
      country: country,
      latLon: (lat, lon),
    );
  }
}
