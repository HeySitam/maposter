import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_to_poster/features/poster/presentation/notifiers/providers.dart';
import 'package:map_to_poster/features/poster/presentation/screens/poster_screen.dart';
import 'package:maposter/maposter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

String _errorMessage(Object e) => switch (e) {
  DioException(:final error) when error is AppException => error.message,
  AppException(:final message) => message,
  _ => 'Something went wrong. Please try again.',
};

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _cityController = TextEditingController(text: 'Kolkata');
  final _countryController = TextEditingController(text: 'India');
  bool _loading = false;
  bool _generating = false;
  CancelToken? _cancelToken;

  // ── Staged progress state ──────────────────────────────────────────────────
  Timer? _ticker;
  String _stageLabel = '';
  double _shown = 0; // displayed bar fraction (0–1)
  double _ceiling = 0; // upper bound the current stage eases toward
  int _elapsedMs = 0;

  @override
  void dispose() {
    _ticker?.cancel();
    _cancelToken?.cancel();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // Starts the periodic ticker that advances the elapsed timer and eases the
  // bar toward the current stage's ceiling (so it always moves but never lies
  // about being finished).
  void _startProgress() {
    _stageLabel = '';
    _shown = 0;
    _ceiling = 0;
    _elapsedMs = 0;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return;
      setState(() {
        _elapsedMs += 120;
        _shown += (_ceiling - _shown) * 0.06; // decelerating approach
      });
    });
  }

  // Moves to a named stage occupying the band [floor, ceiling].
  void _enterStage(String label, double floor, double ceiling) {
    if (!mounted) return;
    setState(() {
      _stageLabel = label;
      _ceiling = ceiling;
      if (_shown < floor) _shown = floor;
    });
  }

  void _stopProgress() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> _testGeocoding() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(
        geocodingProvider((
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
        )).future,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.displayName)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorMessage(e))));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _generateImage() async {
    // Cancel any in-flight Overpass requests from a previous Generate press
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final token = _cancelToken!;

    final city = _cityController.text.trim();
    final country = _countryController.text.trim();

    setState(() => _generating = true);
    _startProgress();
    try {
      _enterStage('Locating $city…', 0, 0.15);
      final coords = await ref.read(
        geocodingProvider((city: city, country: country)).future,
      );

      final mapData = await ref
          .read(mapPosterEngineProvider)
          .fetchMapData(
            (coords.latitude, coords.longitude),
            token: token,
            onProgress: (p) {
              final (label, floor, ceiling) = switch (p.stage) {
                MapDataStage.roads => ('Mapping roads…', 0.15, 0.55),
                MapDataStage.water => ('Adding water…', 0.55, 0.78),
                MapDataStage.parks => ('Adding parks…', 0.78, 0.95),
              };
              _enterStage(label, floor, ceiling);
            },
          );

      _stopProgress();
      if (mounted) {
        setState(() => _generating = false);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PosterScreen(
              mapData: mapData,
              cityName: city,
              countryName: country,
              latitude: coords.latitude,
              longitude: coords.longitude,
            ),
          ),
        );
      }
    } catch (e) {
      // Silently ignore user-initiated cancellation (no SnackBar needed)
      if (e is DioException && e.type == DioExceptionType.cancel) return;
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorMessage(e))));
      }
    } finally {
      _stopProgress();
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _loading || _generating;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: busy ? null : _testGeocoding,
                child: const Text('Test Geocoding API'),
              ),
              if (_loading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: busy ? null : _generateImage,
                child: const Text('Generate Image'),
              ),
              if (_generating) ...[
                const SizedBox(height: 24),
                _GenerationProgress(
                  city: _cityController.text.trim(),
                  fraction: _shown,
                  label: _stageLabel,
                  elapsed: Duration(milliseconds: _elapsedMs),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A labeled progress bar shown while a poster is being generated: a title with
/// the live percentage, a determinate bar, the current stage with a small
/// spinner, and an elapsed-time + reassurance line.
class _GenerationProgress extends StatelessWidget {
  const _GenerationProgress({
    required this.city,
    required this.fraction,
    required this.label,
    required this.elapsed,
  });

  final String city;
  final double fraction;
  final String label;
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = fraction.clamp(0.0, 1.0);
    final pct = (value * 100).round();
    final title = city.isEmpty ? 'Generating poster' : 'Generating $city poster';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$pct%',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: value),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            builder: (_, v, __) => LinearProgressIndicator(
              value: v,
              minHeight: 6,
              backgroundColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${elapsed.inSeconds}s · first load for a city is cached afterward',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
