import 'package:map_to_poster/core/utils/mercator.dart';
import 'package:map_to_poster/features/poster/domain/entities/map_data.dart';

enum OverpassQueryType { roads, water, parks }

abstract interface class OverpassRemoteDatasource {
  Future<List<RoadSegment>> fetchRoads(LatLon center, double radiusMeters);
  Future<List<MapFeature>> fetchWaterFeatures(LatLon center, double radiusMeters);
  Future<List<MapFeature>> fetchParkFeatures(LatLon center, double radiusMeters);
}
