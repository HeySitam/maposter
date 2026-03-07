import 'package:map_to_poster/features/poster/data/datasources/local/nominatim_local_datasource.dart';
import 'package:map_to_poster/features/poster/data/datasources/remote/nominatim_remote_datasource.dart';
import 'package:map_to_poster/features/poster/domain/entities/city_coordinates.dart';
import 'package:map_to_poster/features/poster/domain/repositories/geocoding_repository.dart';

class GeocodingRepositoryImpl implements GeocodingRepository {
  const GeocodingRepositoryImpl(this._remote, this._local);

  final NominatimRemoteDatasource _remote;
  final NominatimLocalDatasource _local;

  @override
  Future<CityCoordinates> getCoordinates(String city, String country) async {
    final key =
        'geocoding_${city.toLowerCase().trim()}_${country.toLowerCase().trim()}';

    final cached = _local.get(key);
    if (cached != null) return cached;

    final result = await _remote.searchCity(city, country);
    await _local.put(key, result);
    return result;
  }
}
