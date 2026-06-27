import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maposter/src/utils/mercator.dart';

part 'map_data.freezed.dart';

/// Road class, mapped from OpenStreetMap `highway` tags. Drives stroke width
/// and color when rendering.
enum RoadType { motorway, primary, secondary, tertiary, residential, unknown }

/// Filled-polygon feature class (water bodies or parks/greenery).
enum FeatureType { water, park }

/// A single road as an ordered list of lat/lon points, tagged with its [type].
@freezed
abstract class RoadSegment with _$RoadSegment {
  const factory RoadSegment({
    required List<LatLon> coordinates,
    required RoadType type,
  }) = _RoadSegment;
}

/// A filled polygon (e.g. a lake or park). [rings] holds one or more closed
/// rings: the first is the outer ring, any others are holes.
@freezed
abstract class MapFeature with _$MapFeature {
  const factory MapFeature({
    required List<List<LatLon>> rings,
    required FeatureType type,
  }) = _MapFeature;
}

/// The full set of rendered map geometry for one poster: roads, water and park
/// features, plus the [bounds] used to project them onto the canvas.
@freezed
abstract class MapData with _$MapData {
  const MapData._();

  const factory MapData({
    required List<RoadSegment> roads,
    required List<MapFeature> waterFeatures,
    required List<MapFeature> parkFeatures,
    required LatLonBounds bounds,
  }) = _MapData;

  /// Water and park features combined, in draw order (water first).
  List<MapFeature> get allFeatures => [...waterFeatures, ...parkFeatures];
}
