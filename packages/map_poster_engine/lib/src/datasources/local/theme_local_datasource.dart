import 'package:map_poster_engine/src/entities/map_theme.dart';

abstract interface class ThemeLocalDatasource {
  Future<List<MapTheme>> loadAll();
  Future<MapTheme> loadTheme(String id);
}
