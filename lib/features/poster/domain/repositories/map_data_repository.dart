import 'package:dio/dio.dart';
import 'package:map_to_poster/core/utils/mercator.dart';
import 'package:map_to_poster/features/poster/domain/entities/map_data.dart';

abstract interface class MapDataRepository {
  Future<MapData> fetchMapData(LatLon center, double radiusMeters, {CancelToken? token});
}
