import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:map_to_poster/features/poster/domain/entities/map_data.dart';
import 'package:map_to_poster/features/poster/domain/entities/map_theme.dart';
import 'package:map_to_poster/features/poster/presentation/notifiers/providers.dart';
import 'package:map_to_poster/features/poster/presentation/painters/map_poster_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum _ExportAction { gallery, png, pdf }

class ExportSheet extends ConsumerStatefulWidget {
  const ExportSheet({
    super.key,
    required this.mapData,
    required this.theme,
    required this.cityName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
  });

  static const Size posterSize = Size(1200, 1600);

  final MapData mapData;
  final MapTheme theme;
  final String cityName;
  final String countryName;
  final double latitude;
  final double longitude;

  @override
  ConsumerState<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends ConsumerState<ExportSheet> {
  _ExportAction? _busy;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Export poster',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _tile(
              icon: Icons.image_outlined,
              label: 'Save to Photos',
              action: _ExportAction.gallery,
              onTap: _saveToGallery,
            ),
            _tile(
              icon: Icons.share_outlined,
              label: 'Share PNG',
              action: _ExportAction.png,
              onTap: _sharePng,
            ),
            _tile(
              icon: Icons.picture_as_pdf_outlined,
              label: 'Share PDF',
              action: _ExportAction.pdf,
              onTap: _sharePdf,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required _ExportAction action,
    required Future<void> Function() onTap,
  }) {
    final isActive = _busy == action;
    final disabled = _busy != null;
    return ListTile(
      enabled: !disabled,
      leading: Icon(icon, color: disabled ? Colors.white38 : Colors.white),
      title: Text(
        label,
        style: TextStyle(color: disabled ? Colors.white38 : Colors.white),
      ),
      trailing: isActive
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: disabled ? null : () => _run(action, onTap),
    );
  }

  Future<void> _run(
    _ExportAction action,
    Future<void> Function() body,
  ) async {
    setState(() => _busy = action);
    try {
      await body();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  MapPosterPainter _buildPainter() => MapPosterPainter(
        mapData: widget.mapData,
        theme: widget.theme,
        cityName: widget.cityName,
        countryName: widget.countryName,
        latitude: widget.latitude,
        longitude: widget.longitude,
      );

  String _baseFilename() {
    final now = DateTime.now();
    final stamp = '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}';
    final safeCity =
        widget.cityName.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
    return '${safeCity}_${widget.theme.id}_$stamp';
  }

  Future<Uint8List> _renderPng() async {
    final exporter = ref.read(posterExporterProvider);
    return exporter.exportPng(_buildPainter(), ExportSheet.posterSize);
  }

  Future<void> _saveToGallery() async {
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      if (!granted) {
        throw Exception('Photos permission denied');
      }
    }
    final bytes = await _renderPng();
    await Gal.putImageBytes(bytes, name: _baseFilename());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to Photos')),
    );
    Navigator.of(context).pop();
  }

  Future<void> _sharePng() async {
    final bytes = await _renderPng();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${_baseFilename()}.png');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: '${widget.cityName} map poster',
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _sharePdf() async {
    final png = await _renderPng();
    final exporter = ref.read(posterExporterProvider);
    final pdfBytes = await exporter.exportPdf(png, ExportSheet.posterSize);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${_baseFilename()}.pdf');
    await file.writeAsBytes(pdfBytes, flush: true);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      text: '${widget.cityName} map poster',
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
