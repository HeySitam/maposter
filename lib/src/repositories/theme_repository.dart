import 'package:maposter/src/entities/map_theme.dart';

abstract interface class ThemeRepository {
  Future<List<MapTheme>> getAllThemes();
  Future<MapTheme> getTheme(String id);
}
