import 'package:flutter/painting.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts a CSS hex color string (e.g. `"#F5EDE4"`) to [Color] and back.
/// Use as `@ColorConverter()` on [Color] fields in freezed/json_serializable classes.
class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    final hex = json.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  String toJson(Color color) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }
}
