import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:map_to_poster/core/constants/app_constants.dart';
import 'package:map_to_poster/core/errors/app_exception.dart';
import 'package:map_to_poster/features/poster/domain/entities/map_theme.dart';

const _themeIds = [
  'autumn', 'blueprint', 'contrast_zones', 'copper_patina',
  'emerald', 'forest', 'gradient_roads', 'japanese_ink',
  'midnight_blue', 'monochrome_blue', 'neon_cyberpunk', 'noir',
  'ocean', 'pastel_dream', 'sunset', 'terracotta', 'warm_beige',
];

const _requiredKeys = [
  'name', 'description', 'bg', 'text', 'gradient_color',
  'water', 'parks', 'road_motorway', 'road_primary',
  'road_secondary', 'road_tertiary', 'road_residential', 'road_default',
];

class ThemeDatasource {
  final _cache = <String, MapTheme>{};

  Future<List<MapTheme>> loadAll() async {
    if (_cache.isNotEmpty) return _cache.values.toList();
    for (final id in _themeIds) {
      _cache[id] = await _load(id);
    }
    return _cache.values.toList();
  }

  Future<MapTheme> loadTheme(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final theme = await _load(id);
    _cache[id] = theme;
    return theme;
  }

  Future<MapTheme> _load(String id) async {
    try {
      final raw = await rootBundle.loadString(
        '${AppConstants.themesAssetPath}$id.json',
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;

      for (final key in _requiredKeys) {
        if (!json.containsKey(key)) {
          throw AssetException('Theme "$id" missing required key: "$key"');
        }
      }

      // Inject id (derived from filename, not stored in JSON)
      json['id'] = id;
      return MapTheme.fromJson(json);
    } on AssetException {
      rethrow;
    } catch (e) {
      throw AssetException('Failed to load theme "$id": $e');
    }
  }
}
