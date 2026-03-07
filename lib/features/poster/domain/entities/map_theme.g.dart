// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapTheme _$MapThemeFromJson(Map<String, dynamic> json) => _MapTheme(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  bg: const ColorConverter().fromJson(json['bg'] as String),
  text: const ColorConverter().fromJson(json['text'] as String),
  gradientColor: const ColorConverter().fromJson(
    json['gradient_color'] as String,
  ),
  water: const ColorConverter().fromJson(json['water'] as String),
  parks: const ColorConverter().fromJson(json['parks'] as String),
  roadMotorway: const ColorConverter().fromJson(
    json['road_motorway'] as String,
  ),
  roadPrimary: const ColorConverter().fromJson(json['road_primary'] as String),
  roadSecondary: const ColorConverter().fromJson(
    json['road_secondary'] as String,
  ),
  roadTertiary: const ColorConverter().fromJson(
    json['road_tertiary'] as String,
  ),
  roadResidential: const ColorConverter().fromJson(
    json['road_residential'] as String,
  ),
  roadDefault: const ColorConverter().fromJson(json['road_default'] as String),
);

Map<String, dynamic> _$MapThemeToJson(_MapTheme instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'bg': const ColorConverter().toJson(instance.bg),
  'text': const ColorConverter().toJson(instance.text),
  'gradient_color': const ColorConverter().toJson(instance.gradientColor),
  'water': const ColorConverter().toJson(instance.water),
  'parks': const ColorConverter().toJson(instance.parks),
  'road_motorway': const ColorConverter().toJson(instance.roadMotorway),
  'road_primary': const ColorConverter().toJson(instance.roadPrimary),
  'road_secondary': const ColorConverter().toJson(instance.roadSecondary),
  'road_tertiary': const ColorConverter().toJson(instance.roadTertiary),
  'road_residential': const ColorConverter().toJson(instance.roadResidential),
  'road_default': const ColorConverter().toJson(instance.roadDefault),
};
