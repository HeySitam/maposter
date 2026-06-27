import 'package:maposter/src/entities/map_theme.dart';

abstract interface class ThemeLocalDatasource {
  Future<List<MapTheme>> loadAll();
  Future<MapTheme> loadTheme(String id);
}
