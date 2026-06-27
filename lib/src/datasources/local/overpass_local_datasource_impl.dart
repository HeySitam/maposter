import 'dart:convert';

import 'package:maposter/src/cache/cache_store.dart';
import 'package:maposter/src/datasources/local/overpass_local_datasource.dart';
import 'package:maposter/src/entities/map_data.dart';
import 'package:maposter/src/utils/mercator.dart';

// ── Serialization helpers ─────────────────────────────────────────────────────

List<double> _latLonToJson(LatLon ll) => [ll.$1, ll.$2];

LatLon _latLonFromJson(dynamic d) {
  final list = d as List;
  return ((list[0] as num).toDouble(), (list[1] as num).toDouble());
}

Map<String, dynamic> _roadSegmentToJson(RoadSegment r) => {
  'coords': [for (final ll in r.coordinates) _latLonToJson(ll)],
  'type': r.type.name,
};

RoadSegment _roadSegmentFromJson(Map<String, dynamic> m) => RoadSegment(
  coordinates: [for (final ll in m['coords'] as List) _latLonFromJson(ll)],
  type: RoadType.values.byName(m['type'] as String),
);

Map<String, dynamic> _mapFeatureToJson(MapFeature f) => {
  'rings': [
    for (final ring in f.rings) [for (final ll in ring) _latLonToJson(ll)],
  ],
  'type': f.type.name,
};

MapFeature _mapFeatureFromJson(Map<String, dynamic> m) => MapFeature(
  rings: [
    for (final ring in m['rings'] as List)
      [for (final ll in ring as List) _latLonFromJson(ll)],
  ],
  type: FeatureType.values.byName(m['type'] as String),
);

// ── Impl ──────────────────────────────────────────────────────────────────────

class OverpassLocalDatasourceImpl implements OverpassLocalDatasource {
  OverpassLocalDatasourceImpl(this._cache);

  final CacheStore _cache;

  @override
  Future<List<RoadSegment>?> getRoads(String key) async {
    final cached = await _cache.read(key);
    if (cached == null) return null;
    final list = jsonDecode(cached) as List;
    return [
      for (final m in list) _roadSegmentFromJson(m as Map<String, dynamic>),
    ];
  }

  @override
  Future<void> putRoads(String key, List<RoadSegment> roads) => _cache.write(
    key,
    jsonEncode([for (final r in roads) _roadSegmentToJson(r)]),
  );

  @override
  Future<List<MapFeature>?> getFeatures(String key) async {
    final cached = await _cache.read(key);
    if (cached == null) return null;
    final list = jsonDecode(cached) as List;
    return [
      for (final m in list) _mapFeatureFromJson(m as Map<String, dynamic>),
    ];
  }

  @override
  Future<void> putFeatures(String key, List<MapFeature> features) => _cache
      .write(key, jsonEncode([for (final f in features) _mapFeatureToJson(f)]));
}
