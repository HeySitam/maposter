import 'package:dio/dio.dart';
import 'package:map_to_poster/core/errors/app_exception.dart';
import 'package:map_to_poster/core/network/rate_limiter.dart';
import 'package:map_to_poster/features/poster/data/models/city_coordinates_model.dart';

class NominatimDatasource {
  NominatimDatasource(this._dio, this._rateLimiter);

  final Dio _dio;
  final RateLimiter _rateLimiter;

  Future<CityCoordinatesModel> searchCity(String city, String country) =>
      _rateLimiter.run(() async {
        final response = await _dio.get<List<dynamic>>(
          '/search',
          queryParameters: {
            'city': city,
            'country': country,
            'format': 'jsonv2',
            'limit': 1,
          },
        );

        final results = response.data;
        if (results == null || results.isEmpty) {
          throw GeocodingException('No results found for "$city, $country"');
        }

        return CityCoordinatesModel.fromNominatim(
          results.first as Map<String, dynamic>,
          city: city,
          country: country,
        );
      });
}
