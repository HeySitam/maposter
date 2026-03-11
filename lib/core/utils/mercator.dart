import 'dart:math';

import 'package:flutter/painting.dart';

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

  /// Over-fetch radius to compensate for aspect-ratio crop.
  /// Ported from Python: dist * (max(h,w) / min(h,w)) / 4
  /// Use poster dimensions in any consistent unit (inches, px, etc.).
  static double computeCompensatedDist(
    double dist,
    double width,
    double height,
  ) =>
      dist * (max(height, width) / min(height, width)) / 4;

  /// Projects [coords] to screen [Offset]s that fit within [canvasSize].
  ///
  /// Uses [bounds] as the viewport — the NW corner maps to near (0, 0).
  /// Preserves aspect ratio: the map fits fully inside the canvas with
  /// possible blank space on one axis (letterbox / pillarbox).
  static List<Offset> projectToScreen(
    List<LatLon> coords,
    Size canvasSize,
    LatLonBounds bounds, {
    double zoomFactor = 1.0,
  }) {
    final origin = (bounds.north, bounds.west); // NW corner = (0, 0) in metre space

    // Project SE corner to measure the full metre extent of the viewport
    final (extentX, extentY) = project((bounds.south, bounds.east), origin);
    // extentX > 0 (east of origin), extentY < 0 (south of origin)
    final mercWidth = extentX;   // metres west→east
    final mercHeight = -extentY; // metres north→south (negated to be positive)

    // Cover the full canvas — scale to the larger axis so no black edges remain.
    // Overflow in the other axis is clipped by the canvas bounds.
    // zoomFactor > 1 zooms in further from center (center-crop effect).
    final scale = max(canvasSize.width / mercWidth, canvasSize.height / mercHeight)
        * zoomFactor;

    // Center the map within the canvas (letterbox / pillarbox offset)
    final offsetX = (canvasSize.width - mercWidth * scale) / 2;
    final offsetY = (canvasSize.height - mercHeight * scale) / 2;

    return coords.map((coord) {
      final (x, y) = project(coord, origin);
      return Offset(x * scale + offsetX, -y * scale + offsetY);
    }).toList();
  }
}
