import 'dart:async';

import 'package:country_state_city/country_state_city.dart' as csc;
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
  // ── Cascading selection ────────────────────────────────────────────────────
  List<csc.Country> _countries = [];
  List<csc.State> _states = [];
  List<csc.City> _cities = [];
  csc.Country? _country;
  csc.State? _state;
  csc.City? _city;
  bool _loadingCountries = true;
  bool _loadingStates = false;
  bool _loadingCities = false;

  bool _loading = false; // geocoding test
  bool _generating = false;
  CancelToken? _cancelToken;

  // ── Staged progress state ──────────────────────────────────────────────────
  Timer? _ticker;
  String _stageLabel = '';
  double _shown = 0;
  double _ceiling = 0;
  int _elapsedMs = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _cancelToken?.cancel();
    super.dispose();
  }

  // Loads countries and defaults to India → West Bengal → Kolkata.
  Future<void> _init() async {
    final countries = await csc.getAllCountries();
    countries.sort((a, b) => a.name.compareTo(b.name));
    if (!mounted) return;
    final india = countries.firstWhere(
      (c) => c.isoCode == 'IN',
      orElse: () => countries.first,
    );
    setState(() {
      _countries = countries;
      _loadingCountries = false;
    });
    await _selectCountry(
      india,
      preferState: 'West Bengal',
      preferCity: 'Kolkata',
    );
  }

  Future<void> _selectCountry(
    csc.Country country, {
    String? preferState,
    String? preferCity,
  }) async {
    setState(() {
      _country = country;
      _state = null;
      _city = null;
      _states = [];
      _cities = [];
      _loadingStates = true;
    });
    final states = await csc.getStatesOfCountry(country.isoCode);
    states.sort((a, b) => a.name.compareTo(b.name));
    if (!mounted) return;
    setState(() {
      _states = states;
      _loadingStates = false;
    });

    if (states.isEmpty) {
      // Countries without states (e.g. Singapore): cities sit under the country.
      await _loadCities(
        () => csc.getCountryCities(country.isoCode),
        preferCity: preferCity,
      );
      return;
    }
    final state = preferState != null
        ? states.firstWhere(
            (s) => s.name == preferState,
            orElse: () => states.first,
          )
        : states.first;
    await _selectState(state, preferCity: preferCity);
  }

  Future<void> _selectState(csc.State state, {String? preferCity}) async {
    setState(() {
      _state = state;
      _city = null;
      _cities = [];
    });
    await _loadCities(
      () => csc.getStateCities(state.countryCode, state.isoCode),
      preferCity: preferCity,
    );
  }

  Future<void> _loadCities(
    Future<List<csc.City>> Function() fetch, {
    String? preferCity,
  }) async {
    setState(() => _loadingCities = true);
    final cities = await fetch();
    cities.sort((a, b) => a.name.compareTo(b.name));
    if (!mounted) return;
    setState(() {
      _cities = cities;
      _loadingCities = false;
      _city = preferCity != null && cities.any((c) => c.name == preferCity)
          ? cities.firstWhere((c) => c.name == preferCity)
          : (cities.isNotEmpty ? cities.first : null);
    });
  }

  // ── Progress ticker ────────────────────────────────────────────────────────
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
        _shown += (_ceiling - _shown) * 0.06;
      });
    });
  }

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
    final city = _city, country = _country;
    if (city == null || country == null) return;
    setState(() => _loading = true);
    try {
      final result = await ref.read(
        geocodingProvider((city: city.name, country: country.name)).future,
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
    final city = _city, country = _country;
    if (city == null || country == null) return;

    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final token = _cancelToken!;

    setState(() => _generating = true);
    _startProgress();
    try {
      _enterStage('Locating ${city.name}…', 0, 0.15);
      final coords = await ref.read(
        geocodingProvider((city: city.name, country: country.name)).future,
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
              cityName: city.name,
              countryName: country.name,
              latitude: coords.latitude,
              longitude: coords.longitude,
            ),
          ),
        );
      }
    } catch (e) {
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
      body: SafeArea(
        child: _loadingCountries
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CascadeDropdown<csc.Country>(
                        label: 'Country',
                        value: _country,
                        items: _countries,
                        labelOf: (c) => c.name,
                        enabled: !_generating,
                        onSelected: (c) => _selectCountry(c),
                      ),
                      if (_loadingStates || _states.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _CascadeDropdown<csc.State>(
                          // Rebuild (reset displayed value) when the country changes.
                          key: ValueKey('state-${_country?.isoCode}'),
                          label: 'State / Region',
                          value: _state,
                          items: _states,
                          labelOf: (s) => s.name,
                          loading: _loadingStates,
                          enabled: !_generating,
                          onSelected: (s) => _selectState(s),
                        ),
                      ],
                      const SizedBox(height: 12),
                      _CascadeDropdown<csc.City>(
                        key: ValueKey(
                          'city-${_country?.isoCode}-${_state?.isoCode}',
                        ),
                        label: 'City',
                        value: _city,
                        items: _cities,
                        labelOf: (c) => c.name,
                        loading: _loadingCities,
                        enabled: !_generating,
                        onSelected: (c) => setState(() => _city = c),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: busy || _city == null
                            ? null
                            : _testGeocoding,
                        child: const Text('Test Geocoding API'),
                      ),
                      if (_loading) ...[
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(),
                      ],
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: busy || _city == null
                            ? null
                            : _generateImage,
                        child: const Text('Generate Image'),
                      ),
                      if (_generating) ...[
                        const SizedBox(height: 24),
                        _GenerationProgress(
                          city: _city?.name ?? '',
                          fraction: _shown,
                          label: _stageLabel,
                          elapsed: Duration(milliseconds: _elapsedMs),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

/// A full-width searchable [DropdownMenu] for one level of the cascade. Shows a
/// small spinner while its options are loading.
class _CascadeDropdown<T> extends StatelessWidget {
  const _CascadeDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onSelected,
    this.loading = false,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final void Function(T) onSelected;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      label: Text(label),
      initialSelection: value,
      enableFilter: true,
      requestFocusOnTap: true,
      expandedInsets: EdgeInsets.zero,
      enabled: enabled && !loading,
      trailingIcon: loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : null,
      dropdownMenuEntries: [
        for (final item in items)
          DropdownMenuEntry(value: item, label: labelOf(item)),
      ],
      onSelected: (v) {
        if (v != null) onSelected(v);
      },
    );
  }
}

/// A labeled progress bar shown while a poster is being generated.
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
    final title = city.isEmpty
        ? 'Generating poster'
        : 'Generating $city poster';

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
