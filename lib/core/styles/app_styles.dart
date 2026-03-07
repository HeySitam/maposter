import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'package:map_to_poster/core/styles/app_colors.dart';

/// Entry point for the design system.
/// Call [AppStyles.init] once from the root widget before using spacing/text.
///
/// Usage:
/// ```dart
/// final p = AppStyles.insets.md;
/// final style = AppStyles.text.h1;
/// final dur = AppStyles.times.medium;
/// ```
abstract final class AppStyles {
  static double _scale = 1.0;

  /// Call this once in the root widget's [build] (after [MediaQuery] is available).
  static void init(BuildContext context) {
    final s = MediaQuery.of(context).size.shortestSide;
    _scale = s > 1000 ? 1.2 : s > 800 ? 1.1 : 1.0;
  }

  static AppInsets get insets => AppInsets(_scale);
  static AppCorners get corners => const AppCorners();
  static AppTimes get times => const AppTimes();
  static AppText get text => AppText(_scale);
  static AppShadows get shadows => const AppShadows();
}

// ── Spacing ───────────────────────────────────────────────────────────────────

class AppInsets {
  const AppInsets(this._s);
  final double _s;

  double get xxs => 2 * _s;
  double get xs => 4 * _s;
  double get sm => 8 * _s;
  double get md => 16 * _s;
  double get lg => 24 * _s;
  double get xl => 32 * _s;
  double get xxl => 48 * _s;
  double get xxxl => 64 * _s;
}

// ── Corner radii ──────────────────────────────────────────────────────────────

class AppCorners {
  const AppCorners();

  double get sm => 4;
  double get md => 12;
  double get lg => 20;
  double get xl => 32;

  BorderRadius radius(double r) => BorderRadius.circular(r);
  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
}

// ── Animation durations ───────────────────────────────────────────────────────

class AppTimes {
  const AppTimes();

  Duration get fast => const Duration(milliseconds: 200);
  Duration get medium => const Duration(milliseconds: 350);
  Duration get slow => const Duration(milliseconds: 600);
  Duration get extraSlow => const Duration(milliseconds: 1000);
}

// ── Typography ────────────────────────────────────────────────────────────────

class AppText {
  const AppText(this._s);
  final double _s;

  double _sp(double size) => size * _s;

  TextStyle get h1 => GoogleFonts.roboto(
        fontSize: _sp(32),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      );

  TextStyle get h2 => GoogleFonts.roboto(
        fontSize: _sp(24),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
      );

  TextStyle get h3 => GoogleFonts.roboto(
        fontSize: _sp(18),
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  TextStyle get body => GoogleFonts.roboto(
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  TextStyle get bodySmall => GoogleFonts.roboto(
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  TextStyle get label => GoogleFonts.roboto(
        fontSize: _sp(11),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
      );

  TextStyle get btn => GoogleFonts.roboto(
        fontSize: _sp(14),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  // Poster-specific: city name displayed on the generated poster
  TextStyle get posterCity => GoogleFonts.roboto(
        fontSize: _sp(28),
        fontWeight: FontWeight.w300,
        letterSpacing: 4,
      );

  TextStyle get posterCountry => GoogleFonts.roboto(
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        letterSpacing: 6,
      );
}

// ── Shadows ───────────────────────────────────────────────────────────────────

class AppShadows {
  const AppShadows();

  List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ];

  List<Shadow> get text => [
        Shadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];
}
