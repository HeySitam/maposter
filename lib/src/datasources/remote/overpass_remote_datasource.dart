import 'package:dio/dio.dart';
import 'package:maposter/src/entities/map_data.dart';
import 'package:maposter/src/utils/mercator.dart';

enum OverpassQueryType { roads, water, parks }

abstract interface class OverpassRemoteDatasource {
  Future<List<RoadSegment>> fetchRoads(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  });
  Future<List<MapFeature>> fetchWaterFeatures(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  });
  Future<List<MapFeature>> fetchParkFeatures(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  });
}
