import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_to_poster/features/poster/presentation/notifiers/providers.dart';
import 'package:map_to_poster/features/poster/presentation/widgets/export_sheet.dart';
import 'package:maposter/maposter.dart';

class PosterScreen extends ConsumerWidget {
  const PosterScreen({
    super.key,
    required this.mapData,
    required this.cityName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
  });

  final MapData mapData;
  final String cityName;
  final String countryName;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            tooltip: 'Export',
            onPressed: () => _openExportSheet(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ref.watch(selectedThemeProvider).when(
                    data: (theme) => Center(
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: CustomPaint(
                          painter: MaposterPainter(
                            mapData: mapData,
                            theme: theme,
                            cityName: cityName,
                            countryName: countryName,
                            latitude: latitude,
                            longitude: longitude,
                          ),
                        ),
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Text(
                        'Error loading theme: $e',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
            ),
            const _ThemePickerBar(),
          ],
        ),
      ),
    );
  }

  void _openExportSheet(BuildContext context, WidgetRef ref) {
    final theme = ref.read(selectedThemeProvider).valueOrNull;
    if (theme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Theme still loading — try again.')),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ExportSheet(
        mapData: mapData,
        theme: theme,
        cityName: cityName,
        countryName: countryName,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}

// ── Theme picker bar ──────────────────────────────────────────────────────────

class _ThemePickerBar extends ConsumerWidget {
  const _ThemePickerBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedThemeIdProvider);
    return ref.watch(allThemesProvider).when(
          data: (themes) => SizedBox(
            height: 106,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: themes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final theme = themes[i];
                return GestureDetector(
                  onTap: () =>
                      ref.read(selectedThemeIdProvider.notifier).state =
                          theme.id,
                  child: _ThemeSwatch(
                    theme: theme,
                    isSelected: theme.id == selectedId,
                  ),
                );
              },
            ),
          ),
          loading: () => const SizedBox(height: 106),
          error: (_, __) => const SizedBox(height: 106),
        );
  }
}

// ── Theme swatch ──────────────────────────────────────────────────────────────

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({required this.theme, required this.isSelected});

  final MapTheme theme;
  final bool isSelected;

  static const double _w = 60;
  static const double _h = 72;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _w,
          height: _h,
          decoration: BoxDecoration(
            color: theme.bg,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : Border.all(color: Colors.white24, width: 1),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 8,
                right: 8,
                child: Container(height: 2, color: theme.roadPrimary),
              ),
              Positioned(
                top: 28,
                left: 8,
                right: 8,
                child: Container(height: 1.5, color: theme.roadSecondary),
              ),
              Positioned(
                top: 34,
                left: 8,
                right: 8,
                child: Container(height: 1, color: theme.roadResidential),
              ),
              Positioned(
                bottom: 7,
                right: 7,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: theme.water,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: _w,
          child: Text(
            theme.name,
            style: const TextStyle(color: Colors.white70, fontSize: 9),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
