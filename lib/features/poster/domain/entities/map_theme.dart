import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:map_to_poster/core/utils/color_converter.dart';

part 'map_theme.freezed.dart';
part 'map_theme.g.dart';

@freezed
abstract class MapTheme with _$MapTheme {
  const MapTheme._();

  const factory MapTheme({
    required String id,
    required String name,
    required String description,
    @ColorConverter() required Color bg,
    @ColorConverter() required Color text,
    @JsonKey(name: 'gradient_color') @ColorConverter() required Color gradientColor,
    @ColorConverter() required Color water,
    @ColorConverter() required Color parks,
    @JsonKey(name: 'road_motorway') @ColorConverter() required Color roadMotorway,
    @JsonKey(name: 'road_primary') @ColorConverter() required Color roadPrimary,
    @JsonKey(name: 'road_secondary') @ColorConverter() required Color roadSecondary,
    @JsonKey(name: 'road_tertiary') @ColorConverter() required Color roadTertiary,
    @JsonKey(name: 'road_residential') @ColorConverter() required Color roadResidential,
    @JsonKey(name: 'road_default') @ColorConverter() required Color roadDefault,
  }) = _MapTheme;

  factory MapTheme.fromJson(Map<String, dynamic> json) =>
      _$MapThemeFromJson(json);

  Color roadColor(String roadType) => switch (roadType) {
        'motorway' || 'trunk' => roadMotorway,
        'primary' => roadPrimary,
        'secondary' => roadSecondary,
        'tertiary' => roadTertiary,
        'residential' || 'living_street' => roadResidential,
        _ => roadDefault,
      };
}
