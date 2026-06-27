import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:map_poster_engine/src/constants/engine_constants.dart';
import 'package:map_poster_engine/src/datasources/local/theme_local_datasource.dart';
import 'package:map_poster_engine/src/entities/map_theme.dart';
import 'package:map_poster_engine/src/errors/app_exception.dart';

const _requiredKeys = [
  'name', 'description', 'bg', 'text', 'gradient_color',
  'water', 'parks', 'road_motorway', 'road_primary',
  'road_secondary', 'road_tertiary', 'road_residential', 'road_default',
];

class ThemeLocalDatasourceImpl implements ThemeLocalDatasource {
  final _cache = <String, MapTheme>{};

  @override
  Future<List<MapTheme>> loadAll() async {
    if (_cache.isNotEmpty) return _cache.values.toList();
    for (final id in EngineConstants.bundledThemeIds) {
      _cache[id] = await _load(id);
    }
    return _cache.values.toList();
  }

  @override
  Future<MapTheme> loadTheme(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final theme = await _load(id);
    _cache[id] = theme;
    return theme;
  }

  Future<MapTheme> _load(String id) async {
    try {
      final raw = await rootBundle.loadString(
        '${EngineConstants.themesAssetPath}$id.json',
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;

      for (final key in _requiredKeys) {
        if (!json.containsKey(key)) {
          throw AssetException('Theme "$id" missing required key: "$key"');
        }
      }

      json['id'] = id;
      return MapTheme.fromJson(json);
    } on AssetException {
      rethrow;
    } catch (e) {
      throw AssetException('Failed to load theme "$id": $e');
    }
  }
}
