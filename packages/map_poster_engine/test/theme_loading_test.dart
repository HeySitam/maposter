import 'package:flutter_test/flutter_test.dart';
import 'package:map_poster_engine/map_poster_engine.dart';
import 'package:map_poster_engine/src/datasources/local/theme_local_datasource_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('bundled themes', () {
    test('loadAll returns all 17 themes with ids injected from filenames', () async {
      final themes = await ThemeLocalDatasourceImpl().loadAll();
      expect(themes.length, 17);
      expect(themes.every((t) => t.id.isNotEmpty), isTrue);
      expect(themes.map((t) => t.id), contains('noir'));
    });

    test('loadTheme resolves a single theme by id', () async {
      final noir = await ThemeLocalDatasourceImpl().loadTheme('noir');
      expect(noir.id, 'noir');
      expect(noir.name, isNotEmpty);
    });
  });

  group('MapTheme.fromHex', () {
    test('builds a valid theme from hex strings', () {
      final t = MapTheme.fromHex(
        id: 'brand',
        name: 'Brand',
        bg: '#0A0A0A',
        text: '#E0FF00',
        gradientColor: '#0A0A0A',
        water: '#111111',
        parks: '#1A1A1A',
        roadMotorway: '#E0FF00',
        roadPrimary: '#C8E000',
        roadSecondary: '#96A800',
        roadTertiary: '#647000',
        roadResidential: '#323800',
        roadDefault: '#647000',
      );
      expect(t.id, 'brand');
      expect(t.roadColor('motorway'), t.roadMotorway);
    });
  });

  group('custom themes on the engine', () {
    const config = MapPosterEngineConfig(userAgent: 'test/1.0 (test)');

    MapTheme custom(String id) => MapTheme.fromHex(
          id: id,
          name: id,
          bg: '#000000',
          text: '#FFFFFF',
          gradientColor: '#000000',
          water: '#0A0A0A',
          parks: '#111111',
          roadMotorway: '#FFFFFF',
          roadPrimary: '#E0E0E0',
          roadSecondary: '#B0B0B0',
          roadTertiary: '#808080',
          roadResidential: '#505050',
          roadDefault: '#808080',
        );

    test('a new custom theme is appended (17 -> 18)', () async {
      final engine = MapPosterEngine(config, customThemes: [custom('brand')]);
      final themes = await engine.getAllThemes();
      expect(themes.length, 18);
      expect(themes.map((t) => t.id), contains('brand'));
    });

    test('a custom theme reusing a built-in id overrides it', () async {
      final mine = custom('noir');
      final engine = MapPosterEngine(config, customThemes: [mine]);
      final themes = await engine.getAllThemes();
      expect(themes.length, 17); // overrides, not adds
      expect(await engine.getTheme('noir'), same(mine));
    });
  });
}
