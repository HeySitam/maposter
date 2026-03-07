import 'package:map_to_poster/core/utils/mercator.dart';

class CityCoordinates {
  const CityCoordinates({
    required this.city,
    required this.country,
    required this.latLon,
    this.displayCity,
    this.displayCountry,
  });

  final String city;
  final String country;
  final LatLon latLon;
  final String? displayCity;
  final String? displayCountry;

  String get label => displayCity ?? city;
  String get countryLabel => displayCountry ?? country;
}
