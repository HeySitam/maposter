import 'package:map_poster_engine/src/entities/map_data.dart';

abstract interface class OverpassLocalDatasource {
  Future<List<RoadSegment>?> getRoads(String key);
  Future<void> putRoads(String key, List<RoadSegment> roads);

  Future<List<MapFeature>?> getFeatures(String key);
  Future<void> putFeatures(String key, List<MapFeature> features);
}
