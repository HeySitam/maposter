import 'dart:ui';

import 'package:map_to_poster/features/poster/domain/entities/map_theme.dart';

class MapThemeModel extends MapTheme {
  const MapThemeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.bg,
    required super.text,
    required super.gradientColor,
    required super.water,
    required super.parks,
    required super.roadMotorway,
    required super.roadPrimary,
    required super.roadSecondary,
    required super.roadTertiary,
    required super.roadResidential,
    required super.roadDefault,
  });

  factory MapThemeModel.fromJson(String id, Map<String, dynamic> json) {
    Color hex(String key) {
      final value = (json[key] as String).replaceFirst('#', '');
      return Color(int.parse('FF$value', radix: 16));
    }

    return MapThemeModel(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      bg: hex('bg'),
      text: hex('text'),
      gradientColor: hex('gradient_color'),
      water: hex('water'),
      parks: hex('parks'),
      roadMotorway: hex('road_motorway'),
      roadPrimary: hex('road_primary'),
      roadSecondary: hex('road_secondary'),
      roadTertiary: hex('road_tertiary'),
      roadResidential: hex('road_residential'),
      roadDefault: hex('road_default'),
    );
  }
}
