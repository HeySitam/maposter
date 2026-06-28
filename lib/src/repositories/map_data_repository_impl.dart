import 'package:dio/dio.dart';
import 'package:maposter/src/datasources/local/overpass_local_datasource.dart';
import 'package:maposter/src/datasources/remote/overpass_remote_datasource.dart';
import 'package:maposter/src/entities/map_data.dart';
import 'package:maposter/src/entities/map_data_progress.dart';
import 'package:maposter/src/repositories/map_data_repository.dart';
import 'package:maposter/src/utils/mercator.dart';

class MapDataRepositoryImpl implements MapDataRepository {
  const MapDataRepositoryImpl(this._remote, this._local);

  final OverpassRemoteDatasource _remote;
  final OverpassLocalDatasource _local;

  @override
  Future<MapData> fetchMapData(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
    MapDataProgressCallback? onProgress,
  }) async {
    final (lat, lon) = center;

    // Use the compensated radius for Overpass queries (default A3 portrait 12×16 in)
    final compensated = Mercator.computeCompensatedDist(radiusMeters, 12, 16);
    final prefix =
        '${lat.toStringAsFixed(4)}_${lon.toStringAsFixed(4)}_${compensated.toStringAsFixed(0)}';

    final roadsKey = '${prefix}_roads';
    final waterKey = '${prefix}_water';
    final parksKey = '${prefix}_parks';

    // Cache-aside: check local first, then remote. Each stage reports progress
    // before it runs, flagging whether it will be served from cache (instant).
    final cachedRoads = await _local.getRoads(roadsKey);
    onProgress?.call(
      MapDataProgress(
        stage: MapDataStage.roads,
        index: 0,
        total: 3,
        fromCache: cachedRoads != null,
      ),
    );
    final roads =
        cachedRoads ??
        await _remote.fetchRoads(center, compensated, token: token);
    if (cachedRoads == null) await _local.putRoads(roadsKey, roads);

    final cachedWater = await _local.getFeatures(waterKey);
    onProgress?.call(
      MapDataProgress(
        stage: MapDataStage.water,
        index: 1,
        total: 3,
        fromCache: cachedWater != null,
      ),
    );
    final waterFeatures =
        cachedWater ??
        await _remote.fetchWaterFeatures(center, compensated, token: token);
    if (cachedWater == null) await _local.putFeatures(waterKey, waterFeatures);

    final cachedParks = await _local.getFeatures(parksKey);
    onProgress?.call(
      MapDataProgress(
        stage: MapDataStage.parks,
        index: 2,
        total: 3,
        fromCache: cachedParks != null,
      ),
    );
    final parkFeatures =
        cachedParks ??
        await _remote.fetchParkFeatures(center, compensated, token: token);
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
