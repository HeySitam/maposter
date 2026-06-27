import 'package:dio/dio.dart';
import 'package:map_poster_engine/src/datasources/local/overpass_local_datasource.dart';
import 'package:map_poster_engine/src/datasources/remote/overpass_remote_datasource.dart';
import 'package:map_poster_engine/src/entities/map_data.dart';
import 'package:map_poster_engine/src/repositories/map_data_repository.dart';
import 'package:map_poster_engine/src/utils/mercator.dart';

class MapDataRepositoryImpl implements MapDataRepository {
  const MapDataRepositoryImpl(this._remote, this._local);

  final OverpassRemoteDatasource _remote;
  final OverpassLocalDatasource _local;

  @override
  Future<MapData> fetchMapData(LatLon center, double radiusMeters, {CancelToken? token}) async {
    final (lat, lon) = center;

    // Use the compensated radius for Overpass queries (default A3 portrait 12×16 in)
    final compensated = Mercator.computeCompensatedDist(radiusMeters, 12, 16);
    final prefix =
        '${lat.toStringAsFixed(4)}_${lon.toStringAsFixed(4)}_${compensated.toStringAsFixed(0)}';

    final roadsKey = '${prefix}_roads';
    final waterKey = '${prefix}_water';
    final parksKey = '${prefix}_parks';

    // Cache-aside: check local first, then remote
    final cachedRoads = await _local.getRoads(roadsKey);
    final cachedWater = await _local.getFeatures(waterKey);
    final cachedParks = await _local.getFeatures(parksKey);

    final roads = cachedRoads ?? await _remote.fetchRoads(center, compensated, token: token);
    final waterFeatures =
        cachedWater ?? await _remote.fetchWaterFeatures(center, compensated, token: token);
    final parkFeatures =
        cachedParks ?? await _remote.fetchParkFeatures(center, compensated, token: token);

    // Persist any newly fetched data
    if (cachedRoads == null) await _local.putRoads(roadsKey, roads);
    if (cachedWater == null) await _local.putFeatures(waterKey, waterFeatures);
    if (cachedParks == null) await _local.putFeatures(parksKey, parkFeatures);

    return MapData(
      roads: roads,
      waterFeatures: waterFeatures,
      parkFeatures: parkFeatures,
      bounds: _boundsFromRoads(roads, center, radiusMeters),
    );
  }

  LatLonBounds _boundsFromRoads(
    List<RoadSegment> roads,
    LatLon center,
    double radiusMeters,
  ) {
    if (roads.isEmpty) return Mercator.boundingBox(center, radiusMeters);
    var north = -90.0, south = 90.0, east = -180.0, west = 180.0;
    for (final road in roads) {
      for (final (lat, lon) in road.coordinates) {
        if (lat > north) north = lat;
        if (lat < south) south = lat;
        if (lon > east) east = lon;
        if (lon < west) west = lon;
      }
    }
    return (north: north, south: south, east: east, west: west);
  }
}
