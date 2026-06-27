import 'package:maposter/src/datasources/local/theme_local_datasource.dart';
import 'package:maposter/src/entities/map_theme.dart';
import 'package:maposter/src/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl(
    this._datasource, {
    List<MapTheme> customThemes = const [],
  }) : _customThemes = customThemes;

  final ThemeLocalDatasource _datasource;
  final List<MapTheme> _customThemes;

  @override
  Future<List<MapTheme>> getAllThemes() async {
    final builtIns = await _datasource.loadAll();
    if (_customThemes.isEmpty) return builtIns;
    // Merge by id, preserving built-in order; a custom theme reusing a
    // built-in id overrides it in place, new ones are appended.
    final byId = {for (final t in builtIns) t.id: t};
    for (final t in _customThemes) {
      byId[t.id] = t;
    }
    return byId.values.toList();
  }

  @override
  Future<MapTheme> getTheme(String id) async {
    for (final t in _customThemes) {
      if (t.id == id) return t;
    }
    return _datasource.loadTheme(id);
  }
}
