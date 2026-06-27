import 'package:dio/dio.dart';
import 'package:map_poster_engine/src/entities/map_data.dart';
import 'package:map_poster_engine/src/utils/mercator.dart';

abstract interface class MapDataRepository {
  Future<MapData> fetchMapData(LatLon center, double radiusMeters, {CancelToken? token});
}
