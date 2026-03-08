import 'package:map_to_poster/features/poster/domain/entities/map_data.dart';

abstract interface class OverpassLocalDatasource {
  List<RoadSegment>? getRoads(String key);
  Future<void> putRoads(String key, List<RoadSegment> roads);

  List<MapFeature>? getFeatures(String key);
  Future<void> putFeatures(String key, List<MapFeature> features);
}
