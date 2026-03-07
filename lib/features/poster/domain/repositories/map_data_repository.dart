import 'package:map_to_poster/core/utils/mercator.dart';
import 'package:map_to_poster/features/poster/domain/entities/osm_data.dart';

abstract interface class MapDataRepository {
  Future<OsmData> fetchMapData(LatLon center, double radiusMeters);
}
