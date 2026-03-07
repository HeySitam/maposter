import 'dart:math';

typedef LatLon = (double lat, double lon);
typedef LatLonBounds = ({double north, double south, double east, double west});

abstract final class Mercator {
  static const double _earthRadius = 6371008.8;

  /// Projects [latLon] to (x, y) in metres relative to [origin].
  static (double x, double y) project(LatLon latLon, LatLon origin) {
    final (lat, lon) = latLon;
    final (originLat, originLon) = origin;
    final x = _earthRadius * (lon - originLon) * (pi / 180);
    final y = _earthRadius * log(tan(pi / 4 + lat * pi / 360)) -
        _earthRadius * log(tan(pi / 4 + originLat * pi / 360));
    return (x, y);
  }

  /// Computes a bounding box [radiusMeters] around [center].
  static LatLonBounds boundingBox(LatLon center, double radiusMeters) {
    final (lat, lon) = center;
    final latDelta = (radiusMeters / _earthRadius) * (180 / pi);
    final lonDelta = latDelta / cos(lat * pi / 180);
    return (
      north: lat + latDelta,
      south: lat - latDelta,
      east: lon + lonDelta,
      west: lon - lonDelta,
    );
  }

  /// Overpass bbox string: south,west,north,east
  static String overpassBbox(LatLonBounds bounds) =>
      '${bounds.south},${bounds.west},${bounds.north},${bounds.east}';
}
