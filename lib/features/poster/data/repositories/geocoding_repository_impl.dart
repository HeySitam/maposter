import 'package:map_to_poster/features/poster/data/datasources/nominatim_datasource.dart';
import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';
import 'package:map_to_poster/features/poster/domain/repositories/geocoding_repository.dart';

class GeocodingRepositoryImpl implements GeocodingRepository {
  const GeocodingRepositoryImpl(this._datasource);

  final NominatimDatasource _datasource;

  @override
  Future<CityCoordinates> getCoordinates(String city, String country) =>
      _datasource.searchCity(city, country);
}
