import 'package:map_to_poster/features/poster/domain/entities/map_theme.dart';

abstract interface class ThemeLocalDatasource {
  Future<List<MapTheme>> loadAll();
  Future<MapTheme> loadTheme(String id);
}
