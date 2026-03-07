import 'dart:ui';

class MapTheme {
  const MapTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.bg,
    required this.text,
    required this.gradientColor,
    required this.water,
    required this.parks,
    required this.roadMotorway,
    required this.roadPrimary,
    required this.roadSecondary,
    required this.roadTertiary,
    required this.roadResidential,
    required this.roadDefault,
  });

  final String id;
  final String name;
  final String description;
  final Color bg;
  final Color text;
  final Color gradientColor;
  final Color water;
  final Color parks;
  final Color roadMotorway;
  final Color roadPrimary;
  final Color roadSecondary;
  final Color roadTertiary;
  final Color roadResidential;
  final Color roadDefault;

  Color roadColor(String roadType) => switch (roadType) {
        'motorway' || 'trunk' => roadMotorway,
        'primary' => roadPrimary,
        'secondary' => roadSecondary,
        'tertiary' => roadTertiary,
        'residential' || 'living_street' => roadResidential,
        _ => roadDefault,
      };
}
