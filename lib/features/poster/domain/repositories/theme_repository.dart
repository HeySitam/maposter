import 'package:map_to_poster/features/poster/domain/entities/map_theme.dart';

abstract interface class ThemeRepository {
  Future<List<MapTheme>> getAllThemes();
  Future<MapTheme> getTheme(String id);
}
