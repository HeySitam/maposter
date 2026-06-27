import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:maposter/src/datasources/remote/overpass_remote_datasource.dart';
import 'package:maposter/src/entities/map_data.dart';
import 'package:maposter/src/errors/app_exception.dart';
import 'package:maposter/src/network/rate_limiter.dart';
import 'package:maposter/src/utils/mercator.dart';

// ── Internal helpers (isolate-safe top-level) ─────────────────────────────────

typedef _ParseArgs = ({String json, OverpassQueryType queryType});

class _ResolvedWay {
  _ResolvedWay({
    required this.firstNodeId,
    required this.lastNodeId,
    required this.nodes,
  });

  final int firstNodeId;
  final int lastNodeId;
  final List<LatLon> nodes;

  _ResolvedWay get reversed => _ResolvedWay(
    firstNodeId: lastNodeId,
    lastNodeId: firstNodeId,
    nodes: nodes.reversed.toList(),
  );
}

Map<int, LatLon> _buildNodeMap(List<dynamic> elements) {
  final map = <int, LatLon>{};
  for (final e in elements) {
    if (e case {
      'type': 'node',
      'id': final int id,
      'lat': final num lat,
      'lon': final num lon,
    }) {
      map[id] = (lat.toDouble(), lon.toDouble());
    }
  }
  return map;
}

Map<int, List<int>> _buildWayLookup(List<dynamic> elements) {
  final map = <int, List<int>>{};
  for (final e in elements) {
    if (e case {'type': 'way', 'id': final int id, 'nodes': final List nodes}) {
      map[id] = [for (final n in nodes) n as int];
    }
  }
  return map;
}

LatLonBounds _computeBounds(Map<int, LatLon> nodeMap) {
  if (nodeMap.isEmpty) return (north: 0, south: 0, east: 0, west: 0);
  var north = -90.0, south = 90.0, east = -180.0, west = 180.0;
  for (final (lat, lon) in nodeMap.values) {
    if (lat > north) north = lat;
    if (lat < south) south = lat;
    if (lon > east) east = lon;
    if (lon < west) west = lon;
  }
  return (north: north, south: south, east: east, west: west);
}

RoadType _roadTypeFrom(Object? highway) => switch (highway) {
  'motorway' || 'motorway_link' => .motorway,
  'trunk' || 'trunk_link' || 'primary' || 'primary_link' => .primary,
  'secondary' || 'secondary_link' => .secondary,
  'tertiary' || 'tertiary_link' => .tertiary,
  'residential' || 'living_street' || 'unclassified' => .residential,
  _ => .unknown,
};

List<RoadSegment> _parseRoads(
  List<dynamic> elements,
  Map<int, LatLon> nodeMap,
) {
  final roads = <RoadSegment>[];
  for (final e in elements) {
    if (e case {
      'type': 'way',
      'nodes': final List nodeIds,
      'tags': final Map<dynamic, dynamic> tags,
    }) {
      final highway = tags['highway'];
      if (highway == null) continue;
      final coords = [
        for (final id in nodeIds)
          if (nodeMap[id as int] case final pos?) pos,
      ];
      if (coords.length < 2) continue;
      roads.add(RoadSegment(coordinates: coords, type: _roadTypeFrom(highway)));
    }
  }
  return roads;
}

bool _matchesFeatureType(Map<dynamic, dynamic> tags, FeatureType type) =>
    switch (type) {
      .water =>
        tags['natural'] == 'water' ||
            tags['natural'] == 'bay' ||
            tags['natural'] == 'strait' ||
            tags['waterway'] == 'riverbank',
      .park => tags['leisure'] == 'park' || tags['landuse'] == 'grass',
    };

List<_ResolvedWay> _resolveWays(
  List<int> wayIds,
  Map<int, LatLon> nodeMap,
  Map<int, List<int>> wayLookup,
) {
  final resolved = <_ResolvedWay>[];
  for (final id in wayIds) {
    final nodeIds = wayLookup[id];
    if (nodeIds == null || nodeIds.length < 2) continue;
    final nodes = [
      for (final nid in nodeIds)
        if (nodeMap[nid] case final pos?) pos,
    ];
    if (nodes.length < 2) continue;
    resolved.add(
      _ResolvedWay(
        firstNodeId: nodeIds.first,
        lastNodeId: nodeIds.last,
        nodes: nodes,
      ),
    );
  }
  return resolved;
}

List<LatLon>? _assembleRing(List<_ResolvedWay> ways) {
  if (ways.isEmpty) return null;

  // Single already-closed way
  if (ways.length == 1) {
    final w = ways.first;
    return w.firstNodeId == w.lastNodeId ? w.nodes : null;
  }

  final remaining = ways.toList();
  final chain = <_ResolvedWay>[remaining.removeAt(0)];
  final headId = chain.first.firstNodeId;
  var tailId = chain.first.lastNodeId;

  while (remaining.isNotEmpty) {
    var found = false;
    for (var i = 0; i < remaining.length; i++) {
      final way = remaining[i];
      if (way.firstNodeId == tailId) {
        chain.add(way);
        tailId = way.lastNodeId;
        remaining.removeAt(i);
        found = true;
        break;
      } else if (way.lastNodeId == tailId) {
        final rev = way.reversed;
        chain.add(rev);
        tailId = rev.lastNodeId;
        remaining.removeAt(i);
        found = true;
        break;
      }
    }
    if (!found) return null; // dangling endpoint — malformed relation
  }

  if (tailId != headId) return null; // ring did not close

  final ring = <LatLon>[];
  for (final way in chain) {
    ring.addAll(way.nodes.take(way.nodes.length - 1));
  }
  ring.add(ring.first); // explicitly close
  return ring;
}

List<List<LatLon>> _assembleMultipolygon(
  List<dynamic> members,
  Map<int, LatLon> nodeMap,
  Map<int, List<int>> wayLookup,
) {
  final outerIds = <int>[];
  final innerIds = <int>[];
  for (final m in members) {
    if (m case {
      'type': 'way',
      'ref': final int ref,
      'role': final String role,
    }) {
      if (role == 'outer') outerIds.add(ref);
      if (role == 'inner') innerIds.add(ref);
    }
  }

  final outerRing = _assembleRing(_resolveWays(outerIds, nodeMap, wayLookup));
  if (outerRing == null) return [];

  final innerRing = innerIds.isEmpty
      ? null
      : _assembleRing(_resolveWays(innerIds, nodeMap, wayLookup));

  return [outerRing, if (innerRing != null) innerRing];
}

List<MapFeature> _parsePolygonFeatures(
  List<dynamic> elements,
  Map<int, LatLon> nodeMap,
  Map<int, List<int>> wayLookup,
  FeatureType type,
) {
  final features = <MapFeature>[];

  // Closed ways
  for (final e in elements) {
    if (e case {
      'type': 'way',
      'nodes': final List nodeIds,
      'tags': final Map<dynamic, dynamic> tags,
    }) {
      if (!_matchesFeatureType(tags, type)) continue;
      if (nodeIds.length < 4 || nodeIds.first != nodeIds.last) continue;
      final coords = [
        for (final id in nodeIds)
          if (nodeMap[id as int] case final pos?) pos,
      ];
      if (coords.length < 4) continue;
      features.add(MapFeature(rings: [coords], type: type));
    }
  }

  // Relation multipolygons
  for (final e in elements) {
    if (e case {
      'type': 'relation',
      'members': final List members,
      'tags': final Map<dynamic, dynamic> tags,
    }) {
      if (!_matchesFeatureType(tags, type)) continue;
      final rings = _assembleMultipolygon(members, nodeMap, wayLookup);
      if (rings.isEmpty) continue;
      features.add(MapFeature(rings: rings, type: type));
    }
  }

  return features;
}

// Top-level entry point for compute() — must be top-level, not a closure
// Private (_) is fine since compute() is called from within this same library
MapData _parseOverpassResponse(_ParseArgs args) {
  final decoded = jsonDecode(args.json) as Map<String, dynamic>;
  final elements = decoded['elements'] as List<dynamic>;
  final nodeMap = _buildNodeMap(elements);
  final wayLookup = _buildWayLookup(elements);
  final bounds = _computeBounds(nodeMap);

  return switch (args.queryType) {
    .roads => MapData(
      roads: _parseRoads(elements, nodeMap),
      waterFeatures: const [],
      parkFeatures: const [],
      bounds: bounds,
    ),
    .water => MapData(
      roads: const [],
      waterFeatures: _parsePolygonFeatures(
        elements,
        nodeMap,
        wayLookup,
        .water,
      ),
      parkFeatures: const [],
      bounds: bounds,
    ),
    .parks => MapData(
      roads: const [],
      waterFeatures: const [],
      parkFeatures: _parsePolygonFeatures(elements, nodeMap, wayLookup, .park),
      bounds: bounds,
    ),
  };
}

// ── Datasource impl ───────────────────────────────────────────────────────────

class OverpassRemoteDatasourceImpl implements OverpassRemoteDatasource {
  OverpassRemoteDatasourceImpl(this._dio, this._rateLimiter);

  final Dio _dio;
  final RateLimiter _rateLimiter;

  String _roadsQuery(LatLon center, double radius) {
    final (lat, lon) = center;
    const filter =
        r'^(motorway|motorway_link|trunk|trunk_link'
        r'|primary|primary_link|secondary|secondary_link'
        r'|tertiary|tertiary_link'
        r'|residential|living_street|unclassified)$';
    return '[out:json][timeout:60];\n'
        '(\n'
        '  way["highway"~"$filter"](around:$radius,$lat,$lon);\n'
        ');\n'
        'out body; >; out skel qt;';
  }

  String _waterQuery(LatLon center, double radius) {
    final (lat, lon) = center;
    return '[out:json][timeout:60];\n'
        '(\n'
        '  way["natural"~"water|bay|strait"](around:$radius,$lat,$lon);\n'
        '  relation["natural"~"water|bay|strait"](around:$radius,$lat,$lon);\n'
        '  way["waterway"="riverbank"](around:$radius,$lat,$lon);\n'
        ');\n'
        'out body; >; out skel qt;';
  }

  String _parksQuery(LatLon center, double radius) {
    final (lat, lon) = center;
    return '[out:json][timeout:60];\n'
        '(\n'
        '  way["leisure"="park"](around:$radius,$lat,$lon);\n'
        '  way["landuse"="grass"](around:$radius,$lat,$lon);\n'
        ');\n'
        'out body; >; out skel qt;';
  }

  Future<MapData> _fetch(
    String query,
    OverpassQueryType queryType, {
    CancelToken? token,
  }) => _rateLimiter.run(() async {
    const maxAttempts = 3;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final response = await _dio.post<String>(
          '',
          data: 'data=${Uri.encodeComponent(query)}',
          cancelToken: token,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.plain,
          ),
        );
        final json = response.data;
        if (json == null) {
          throw const OverpassException('Empty response from Overpass');
        }
        return compute(_parseOverpassResponse, (
          json: json,
          queryType: queryType,
        ));
      } on DioException catch (e) {
        if (e.type == DioExceptionType.cancel) rethrow;
        final status = e.response?.statusCode;
        final retryable = status == 429 || status == 502 || status == 504;
        if (retryable && attempt < maxAttempts - 1) {
          await Future.delayed(Duration(seconds: 5 * (attempt + 1)));
          continue;
        }
        rethrow;
      }
    }
    throw const OverpassException('Overpass unavailable after retries');
  });

  @override
  Future<List<RoadSegment>> fetchRoads(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  }) async {
    final data = await _fetch(
      _roadsQuery(center, radiusMeters),
      .roads,
      token: token,
    );
    return data.roads;
  }

  @override
  Future<List<MapFeature>> fetchWaterFeatures(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  }) async {
    final data = await _fetch(
      _waterQuery(center, radiusMeters),
      .water,
      token: token,
    );
    return data.waterFeatures;
  }

  @override
  Future<List<MapFeature>> fetchParkFeatures(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  }) async {
    final data = await _fetch(
      _parksQuery(center, radiusMeters),
      .parks,
      token: token,
    );
    return data.parkFeatures;
  }
}
