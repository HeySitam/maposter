import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:map_poster_engine/src/utils/mercator.dart';

part 'map_data.freezed.dart';

enum RoadType { motorway, primary, secondary, tertiary, residential, unknown }

enum FeatureType { water, park }

@freezed
abstract class RoadSegment with _$RoadSegment {
  const factory RoadSegment({
    required List<LatLon> coordinates,
    required RoadType type,
  }) = _RoadSegment;
}

@freezed
abstract class MapFeature with _$MapFeature {
  const factory MapFeature({
    required List<List<LatLon>> rings,
    required FeatureType type,
  }) = _MapFeature;
}

@freezed
abstract class MapData with _$MapData {
  const MapData._();

  const factory MapData({
    required List<RoadSegment> roads,
    required List<MapFeature> waterFeatures,
    required List<MapFeature> parkFeatures,
    required LatLonBounds bounds,
  }) = _MapData;

  List<MapFeature> get allFeatures => [...waterFeatures, ...parkFeatures];
}
