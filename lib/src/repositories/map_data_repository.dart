import 'package:dio/dio.dart';
import 'package:maposter/src/entities/map_data.dart';
import 'package:maposter/src/utils/mercator.dart';

abstract interface class MapDataRepository {
  Future<MapData> fetchMapData(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  });
}
