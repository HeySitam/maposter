import 'package:map_to_poster/features/poster/data/datasources/local/theme_local_datasource.dart';
import 'package:map_to_poster/features/poster/domain/entities/map_theme.dart';
import 'package:map_to_poster/features/poster/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl(this._datasource);

  final ThemeLocalDatasource _datasource;

  @override
  Future<List<MapTheme>> getAllThemes() => _datasource.loadAll();

  @override
  Future<MapTheme> getTheme(String id) => _datasource.loadTheme(id);
}
