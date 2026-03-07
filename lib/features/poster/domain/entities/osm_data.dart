import 'package:map_to_poster/core/utils/mercator.dart';

enum RoadType { motorway, trunk, primary, secondary, tertiary, residential, livingStreet, unclassified, other }

enum FeatureType { road, water, park, building }

class OsmWay {
  const OsmWay({
    required this.id,
    required this.nodes,
    required this.tags,
    required this.featureType,
    required this.roadType,
  });

  final int id;
  final List<LatLon> nodes;
  final Map<String, String> tags;
  final FeatureType featureType;
  final RoadType? roadType;

  String get osmRoadType => tags['highway'] ?? '';
}

class OsmData {
  const OsmData({required this.ways, required this.center, required this.radiusMeters});

  final List<OsmWay> ways;
  final LatLon center;
  final double radiusMeters;
}
