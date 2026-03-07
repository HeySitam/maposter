import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:map_to_poster/core/constants/app_constants.dart';
import 'package:map_to_poster/core/errors/app_exception.dart';
import 'package:map_to_poster/features/poster/data/models/map_theme_model.dart';

const _themeFiles = [
  'autumn', 'blueprint', 'contrast_zones', 'copper_patina',
  'emerald', 'forest', 'gradient_roads', 'japanese_ink',
  'midnight_blue', 'monochrome_blue', 'neon_cyberpunk', 'noir',
  'ocean', 'pastel_dream', 'sunset', 'terracotta', 'warm_beige',
];

class ThemeDatasource {
  final _cache = <String, MapThemeModel>{};

  Future<List<MapThemeModel>> loadAll() async {
    if (_cache.isNotEmpty) return _cache.values.toList();

    for (final id in _themeFiles) {
      final model = await _load(id);
      _cache[id] = model;
    }
    return _cache.values.toList();
  }

  Future<MapThemeModel> loadTheme(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final model = await _load(id);
    _cache[id] = model;
    return model;
  }

  Future<MapThemeModel> _load(String id) async {
    try {
      final raw = await rootBundle.loadString('${AppConstants.themesAssetPath}$id.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return MapThemeModel.fromJson(id, json);
    } catch (e) {
      throw AssetException('Failed to load theme "$id": $e');
    }
  }
}
