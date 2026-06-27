import 'package:flutter/material.dart';

/// App shell UI colors only.
/// Map rendering colors live in [MapTheme] — do not add them here.
abstract final class AppColors {
  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF242424);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color onBackground = Color(0xFFE8E8E8);
  static const Color onSurface = Color(0xFFCCCCCC);
  static const Color onSurfaceMuted = Color(0xFF888888);

  // ── Accent ───────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFE4935D);
  static const Color accentSubtle = Color(0xFF7A4F34);

  // ── Status ───────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF6BAF8B);

  // ── Dividers / borders ───────────────────────────────────────────────────
  static const Color divider = Color(0xFF2C2C2C);

  // ── Builds Material ThemeData from these colors ──────────────────────────
  static ThemeData toThemeData() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: accent,
      onPrimary: background,
      primaryContainer: accentSubtle,
      onPrimaryContainer: onBackground,
      secondary: accentSubtle,
      onSecondary: onBackground,
      secondaryContainer: surfaceVariant,
      onSecondaryContainer: onSurface,
      surface: surface,
      onSurface: onSurface,
      error: error,
      onError: background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      dividerColor: divider,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: accent),
    );
  }
}
