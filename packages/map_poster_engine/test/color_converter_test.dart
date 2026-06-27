import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_poster_engine/src/utils/color_converter.dart';

void main() {
  const converter = ColorConverter();

  test('round-trips a hex string through Color and back', () {
    expect(converter.toJson(converter.fromJson('#F5EDE4')), '#F5EDE4');
  });

  test('forces full alpha when parsing', () {
    expect(converter.fromJson('#000000').a, 1.0);
    expect(converter.fromJson('#FFFFFF').a, 1.0);
  });

  test('parses channels correctly', () {
    final c = converter.fromJson('#FF8000');
    expect((c.r * 255).round(), 255);
    expect((c.g * 255).round(), 128);
    expect((c.b * 255).round(), 0);
  });

  test('toJson uppercases output', () {
    expect(converter.toJson(const Color(0xFFaabbcc)), '#AABBCC');
  });
}
