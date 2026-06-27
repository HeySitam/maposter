import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maposter/maposter.dart';

void main() {
  group('Mercator.project', () {
    test('projects the origin to (0, 0)', () {
      const origin = (48.8566, 2.3522);
      final (x, y) = Mercator.project(origin, origin);
      expect(x, closeTo(0, 1e-6));
      expect(y, closeTo(0, 1e-6));
    });

    test('east of origin is +x, north of origin is +y', () {
      const origin = (0.0, 0.0);
      final (ex, _) = Mercator.project((0.0, 1.0), origin);
      final (_, ny) = Mercator.project((1.0, 0.0), origin);
      expect(ex, greaterThan(0));
      expect(ny, greaterThan(0));
    });
  });

  group('Mercator.computeCompensatedDist', () {
    test('locks the Python over-fetch formula: dist * (max/min) / 4', () {
      // 18000 * (16/12) / 4 == 6000
      expect(
        Mercator.computeCompensatedDist(18000, 12, 16),
        closeTo(6000, 1e-6),
      );
      // symmetric in width/height (uses max/min)
      expect(
        Mercator.computeCompensatedDist(18000, 16, 12),
        closeTo(Mercator.computeCompensatedDist(18000, 12, 16), 1e-9),
      );
    });
  });

  group('Mercator.boundingBox', () {
    test('is latitudinally symmetric around the center', () {
      const center = (40.0, -74.0);
      final b = Mercator.boundingBox(center, 5000);
      expect(b.north - center.$1, closeTo(center.$1 - b.south, 1e-9));
      expect(b.north, greaterThan(b.south));
      expect(b.east, greaterThan(b.west));
    });
  });

  group('Mercator.projectToScreen', () {
    test('preserves point count and produces finite offsets', () {
      const bounds = (north: 1.0, south: -1.0, east: 1.0, west: -1.0);
      final coords = <LatLon>[(0.0, 0.0), (0.5, 0.5), (-0.5, -0.5)];
      final pts = Mercator.projectToScreen(
        coords,
        const Size(100, 100),
        bounds,
      );
      expect(pts.length, coords.length);
      for (final p in pts) {
        expect(p.dx.isFinite, isTrue);
        expect(p.dy.isFinite, isTrue);
      }
    });

    test('maps the viewport center near the canvas center', () {
      const bounds = (north: 1.0, south: -1.0, east: 1.0, west: -1.0);
      final pts = Mercator.projectToScreen(
        const [(0.0, 0.0)],
        const Size(200, 200),
        bounds,
      );
      expect(pts.single.dx, closeTo(100, 1.0));
      expect(pts.single.dy, closeTo(100, 1.0));
    });
  });
}
