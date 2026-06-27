import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maposter/src/utils/color_converter.dart';

part 'map_theme.freezed.dart';
part 'map_theme.g.dart';

/// A color theme for a poster: background, text, gradient, water/parks fills,
/// and a color per road type. Build one from a JSON map ([MapTheme.fromJson])
/// or from hex strings in code ([MapTheme.fromHex]).
@freezed
abstract class MapTheme with _$MapTheme {
  const MapTheme._();

  const factory MapTheme({
    required String id,
    required String name,
    required String description,
    @ColorConverter() required Color bg,
    @ColorConverter() required Color text,
    @JsonKey(name: 'gradient_color')
    @ColorConverter()
    required Color gradientColor,
    @ColorConverter() required Color water,
    @ColorConverter() required Color parks,
    @JsonKey(name: 'road_motorway')
    @ColorConverter()
    required Color roadMotorway,
    @JsonKey(name: 'road_primary') @ColorConverter() required Color roadPrimary,
    @JsonKey(name: 'road_secondary')
    @ColorConverter()
    required Color roadSecondary,
    @JsonKey(name: 'road_tertiary')
    @ColorConverter()
    required Color roadTertiary,
    @JsonKey(name: 'road_residential')
    @ColorConverter()
    required Color roadResidential,
    @JsonKey(name: 'road_default') @ColorConverter() required Color roadDefault,
  }) = _MapTheme;

  factory MapTheme.fromJson(Map<String, dynamic> json) =>
      _$MapThemeFromJson(json);

  /// Builds a theme from CSS hex color strings (e.g. `'#101010'`).
  ///
  /// Convenient for defining custom themes in code without dealing with
  /// [Color] parsing. Each value must be a 6-digit hex string, optionally
  /// prefixed with `#`. Throws [FormatException] on a malformed value.
  factory MapTheme.fromHex({
    required String id,
    required String name,
    String description = '',
    required String bg,
    required String text,
    required String gradientColor,
    required String water,
    required String parks,
    required String roadMotorway,
    required String roadPrimary,
    required String roadSecondary,
    required String roadTertiary,
    required String roadResidential,
    required String roadDefault,
  }) => MapTheme(
    id: id,
    name: name,
    description: description,
    bg: _hex(bg),
    text: _hex(text),
    gradientColor: _hex(gradientColor),
    water: _hex(water),
    parks: _hex(parks),
    roadMotorway: _hex(roadMotorway),
    roadPrimary: _hex(roadPrimary),
    roadSecondary: _hex(roadSecondary),
    roadTertiary: _hex(roadTertiary),
    roadResidential: _hex(roadResidential),
    roadDefault: _hex(roadDefault),
  );

  static Color _hex(String value) => const ColorConverter().fromJson(value);

  Color roadColor(String roadType) => switch (roadType) {
    'motorway' || 'trunk' => roadMotorway,
    'primary' => roadPrimary,
    'secondary' => roadSecondary,
    'tertiary' => roadTertiary,
    'residential' || 'living_street' => roadResidential,
    _ => roadDefault,
  };
}
