import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_poster_engine/src/entities/map_data.dart';
import 'package:map_poster_engine/src/entities/map_theme.dart';
import 'package:map_poster_engine/src/utils/mercator.dart';

class MapPosterPainter extends CustomPainter {
  const MapPosterPainter({
    required this.mapData,
    required this.theme,
    required this.cityName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
  });

  final MapData mapData;
  final MapTheme theme;
  final String cityName;
  final String countryName;
  final double latitude;
  final double longitude;

  // Reference width for scaling all sizes (logical pixels at design baseline).
  static const double _refWidth = 1080;

  // Zoom factor for map layers: >1 zooms in from center (center-crop effect).
  static const double _zoomFactor = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size); // clip cover-mode overflow to poster bounds
    _drawBackground(canvas, size);
    _drawWater(canvas, size);
    _drawParks(canvas, size);
    _drawRoads(canvas, size);
    _drawGradientFades(canvas, size);
    _drawTextLabels(canvas, size);
  }

  @override
  bool shouldRepaint(MapPosterPainter old) =>
      old.mapData != mapData ||
      old.theme != theme ||
      old.cityName != cityName ||
      old.countryName != countryName ||
      old.latitude != latitude ||
      old.longitude != longitude;

  // ── Background ───────────────────────────────────────────────────────────────

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = theme.bg);
  }

  // ── Water polygons ───────────────────────────────────────────────────────────

  void _drawWater(Canvas canvas, Size size) {
    if (mapData.waterFeatures.isEmpty) return;
    final path = Path();
    for (final feature in mapData.waterFeatures) {
      for (final ring in feature.rings) {
        _addRingToPath(path, ring, size);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = theme.water,
    );
  }

  // ── Park polygons ────────────────────────────────────────────────────────────

  void _drawParks(Canvas canvas, Size size) {
    if (mapData.parkFeatures.isEmpty) return;
    final path = Path();
    for (final feature in mapData.parkFeatures) {
      for (final ring in feature.rings) {
        _addRingToPath(path, ring, size);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = theme.parks,
    );
  }

  void _addRingToPath(Path path, List<LatLon> ring, Size size) {
    if (ring.length < 2) return;
    final pts = Mercator.projectToScreen(ring, size, mapData.bounds, zoomFactor: _zoomFactor);
    path.moveTo(pts.first.dx, pts.first.dy);
    for (final pt in pts.skip(1)) {
      path.lineTo(pt.dx, pt.dy);
    }
    path.close();
  }

  // ── Roads (path batching by type) ────────────────────────────────────────────

  void _drawRoads(Canvas canvas, Size size) {
    if (mapData.roads.isEmpty) return;
    final sf = size.width / _refWidth;

    // One Path per road type → 5-6 draw calls instead of 100k+
    final paths = <RoadType, Path>{
      for (final type in RoadType.values) type: Path(),
    };

    for (final road in mapData.roads) {
      if (road.coordinates.length < 2) continue;
      final pts = Mercator.projectToScreen(
        road.coordinates,
        size,
        mapData.bounds,
        zoomFactor: _zoomFactor,
      );
      final path = paths[road.type]!;
      path.moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) {
        path.lineTo(pt.dx, pt.dy);
      }
    }

    for (final MapEntry(:key, :value) in paths.entries) {
      canvas.drawPath(
        value,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = switch (key) {
                .motorway                => 1.2,
                .primary                 => 1.0,
                .secondary               => 0.8,
                .tertiary                => 0.6,
                .residential || .unknown => 0.4,
              } *
              sf
          ..color = switch (key) {
            .motorway    => theme.roadMotorway,
            .primary     => theme.roadPrimary,
            .secondary   => theme.roadSecondary,
            .tertiary    => theme.roadTertiary,
            .residential => theme.roadResidential,
            .unknown     => theme.roadDefault,
          }
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  // ── Gradient fades ───────────────────────────────────────────────────────────

  void _drawGradientFades(Canvas canvas, Size size) {
    _drawGradientFade(canvas, size, isTop: true);
    _drawGradientFade(canvas, size, isTop: false);
  }

  void _drawGradientFade(Canvas canvas, Size size, {required bool isTop}) {
    final fadeH = size.height * 0.25;
    final rect = isTop
        ? Rect.fromLTWH(0, 0, size.width, fadeH)
        : Rect.fromLTWH(0, size.height - fadeH, size.width, fadeH);

    final gradient = LinearGradient(
      begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [theme.gradientColor, theme.gradientColor.withValues(alpha: 0)],
    );

    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  // ── Text labels ──────────────────────────────────────────────────────────────
  //
  // Python uses transAxes where y=0 is bottom, y=1 is top.
  // Flutter canvas has y=0 at top, so Flutter y = size.height * (1 - transAxes_y)

  void _drawTextLabels(Canvas canvas, Size size) {
    _drawCityLabel(canvas, size);
    _drawDividerLine(canvas, size);
    _drawCountryLabel(canvas, size);
    _drawCoordinatesLabel(canvas, size);
    _drawAttribution(canvas, size);
  }

  void _drawCityLabel(Canvas canvas, Size size) {
    final sf = size.width / _refWidth;
    final isLatin = _isLatinScript(cityName);
    final display = isLatin ? cityName.toUpperCase() : cityName;
    final charCount = cityName.length;
    final base = 60.0 * sf;
    final fontSize =
        charCount > 10 ? max(base * (10 / charCount), 10.0 * sf) : base;

    _paintCentred(
      canvas,
      size,
      text: display,
      style: GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: theme.text,
        letterSpacing: isLatin ? fontSize * 0.15 : 0,
      ),
      yFromTop: size.height * 0.82,
    );
  }

  void _drawDividerLine(Canvas canvas, Size size) {
    final sf = size.width / _refWidth;
    final y = size.height * 0.875;
    final halfLen = size.width * 0.075; // total width = 15% of canvas
    final cx = size.width / 2;
    canvas.drawLine(
      Offset(cx - halfLen, y),
      Offset(cx + halfLen, y),
      Paint()
        ..color = theme.text
        ..strokeWidth = 1.0 * sf,
    );
  }

  void _drawCountryLabel(Canvas canvas, Size size) {
    final sf = size.width / _refWidth;
    _paintCentred(
      canvas,
      size,
      text: countryName.toUpperCase(),
      style: GoogleFonts.roboto(
        fontSize: 28.0 * sf,
        fontWeight: FontWeight.w300,
        color: theme.text,
        letterSpacing: 3.0 * sf,
      ),
      yFromTop: size.height * 0.895,
    );
  }

  void _drawCoordinatesLabel(Canvas canvas, Size size) {
    final sf = size.width / _refWidth;
    final latStr =
        '${latitude.abs().toStringAsFixed(4)}°${latitude >= 0 ? 'N' : 'S'}';
    final lonStr =
        '${longitude.abs().toStringAsFixed(4)}°${longitude >= 0 ? 'E' : 'W'}';
    _paintCentred(
      canvas,
      size,
      text: '$latStr / $lonStr',
      style: GoogleFonts.roboto(
        fontSize: 20.0 * sf,
        fontWeight: FontWeight.w300,
        color: theme.text,
        letterSpacing: 1.5 * sf,
      ),
      yFromTop: size.height * 0.925,
    );
  }

  void _drawAttribution(Canvas canvas, Size size) {
    final sf = size.width / _refWidth;
    final tp = TextPainter(
      text: TextSpan(
        text: '© OpenStreetMap contributors',
        style: GoogleFonts.roboto(
          fontSize: 14.0 * sf,
          fontWeight: FontWeight.w300,
          color: theme.text.withValues(alpha: 0.5),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width * 0.5);

    tp.paint(
      canvas,
      Offset(size.width - tp.width - 16.0 * sf, size.height * 0.975),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  void _paintCentred(
    Canvas canvas,
    Size size, {
    required String text,
    required TextStyle style,
    required double yFromTop,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.width * 0.9);
    tp.paint(canvas, Offset((size.width - tp.width) / 2, yFromTop));
  }

  /// Returns true if every character in [text] is in the Latin Unicode block
  /// (U+0000-U+024F), so we can safely apply letter-spacing and uppercase.
  bool _isLatinScript(String text) => text.runes.every((r) => r <= 0x024F);
}
