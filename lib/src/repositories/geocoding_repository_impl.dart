import 'package:maposter/src/datasources/local/nominatim_local_datasource.dart';
import 'package:maposter/src/datasources/remote/nominatim_remote_datasource.dart';
import 'package:maposter/src/entities/city_coordinates.dart';
import 'package:maposter/src/repositories/geocoding_repository.dart';

class GeocodingRepositoryImpl implements GeocodingRepository {
  const GeocodingRepositoryImpl(this._remote, this._local);

  final NominatimRemoteDatasource _remote;
  final NominatimLocalDatasource _local;

  @override
  Future<CityCoordinates> getCoordinates(String city, String country) async {
    final key =
        'geocoding_${city.toLowerCase().trim()}_${country.toLowerCase().trim()}';

    final cached = await _local.get(key);
    if (cached != null) return cached;

    final result = await _remote.searchCity(city, country);
    await _local.put(key, result);
    return result;
  }
}
