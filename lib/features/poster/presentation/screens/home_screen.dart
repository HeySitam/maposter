import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_to_poster/features/poster/presentation/notifiers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _cityController = TextEditingController(text: 'Kolkata');
  final _countryController = TextEditingController(text: 'India');
  bool _loading = false;

  @override
  void dispose() {
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
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _loading ? null : _testGeocoding,
                child: const Text('Test Geocoding API'),
              ),
              if (_loading) ...[
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
