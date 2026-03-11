import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_to_poster/core/constants/app_constants.dart';
import 'package:map_to_poster/core/errors/app_exception.dart';
import 'package:map_to_poster/features/poster/presentation/notifiers/providers.dart';
import 'package:map_to_poster/features/poster/presentation/screens/poster_screen.dart';

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

  @override
  void dispose() {
    _cancelToken?.cancel();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.displayName)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage(e))),
        );
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

    setState(() => _generating = true);
    try {
      final coords = await ref.read(
        geocodingProvider((
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
        )).future,
      );
      final mapData = await ref
          .read(mapDataRepositoryProvider)
          .fetchMapData(
            (coords.latitude, coords.longitude),
            AppConstants.defaultRadiusMeters,
            token: token,
          );
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PosterScreen(
              mapData: mapData,
              cityName: _cityController.text.trim(),
              countryName: _countryController.text.trim(),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage(e))),
        );
      }
    } finally {
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
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
