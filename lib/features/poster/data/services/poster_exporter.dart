import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:map_to_poster/core/errors/app_exception.dart';
import 'package:map_to_poster/features/poster/presentation/painters/map_poster_painter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PosterExporter {
  const PosterExporter();

  static const double _maxUncompressedMb = 150;

  Future<Uint8List> exportPng(
    MapPosterPainter painter,
    Size posterSize, {
    double scale = 3.0,
  }) async {
    final width = (posterSize.width * scale).toInt();
    final height = (posterSize.height * scale).toInt();

    final estimatedMb = (width * height * 4) / (1024 * 1024);
    if (estimatedMb > _maxUncompressedMb) {
      throw RenderException(
        'Export size ${estimatedMb.toStringAsFixed(0)} MB exceeds the '
        '${_maxUncompressedMb.toStringAsFixed(0)} MB safe limit. '
        'Reduce DPI or poster dimensions.',
      );
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );
    canvas.scale(scale);
    painter.paint(canvas, posterSize);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) {
        throw const RenderException('Failed to encode poster as PNG.');
      }
      return bytes.buffer.asUint8List();
    } finally {
      image.dispose();
      picture.dispose();
    }
  }

  Future<Uint8List> exportPdf(Uint8List png, Size posterSize) async {
    final doc = pw.Document();
    final image = pw.MemoryImage(png);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(posterSize.width, posterSize.height),
        build: (_) => pw.Image(image, fit: pw.BoxFit.cover),
      ),
    );
    return doc.save();
  }
}
