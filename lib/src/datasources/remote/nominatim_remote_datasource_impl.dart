import 'package:dio/dio.dart';
import 'package:maposter/src/datasources/remote/nominatim_remote_datasource.dart';
import 'package:maposter/src/entities/city_coordinates.dart';
import 'package:maposter/src/errors/app_exception.dart';
import 'package:maposter/src/network/rate_limiter.dart';

class NominatimRemoteDatasourceImpl implements NominatimRemoteDatasource {
  NominatimRemoteDatasourceImpl(this._dio, this._rateLimiter);

  final Dio _dio;
  final RateLimiter _rateLimiter;

  @override
  Future<CityCoordinates> searchCity(String city, String country) =>
      _rateLimiter.run(() async {
        final response = await _dio.get<List<dynamic>>(
          '/search',
          queryParameters: {
            'q': '$city,$country',
            'format': 'json',
            'limit': 1,
            'addressdetails': 1,
          },
        );

        final results = response.data;
        if (results == null || results.isEmpty) {
          throw GeocodingException('No results found for "$city, $country"');
        }

        final data = results.first as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;

        return CityCoordinates(
          latitude: double.parse(data['lat'] as String),
          longitude: double.parse(data['lon'] as String),
          displayName: data['display_name'] as String,
          city:
              address?['city'] as String? ??
              address?['town'] as String? ??
              address?['village'] as String?,
          country: address?['country'] as String?,
        );
      });
}
