// lib/presentation/theme/pintig_tokens.dart
import 'package:flutter/material.dart';

class PintigTokens {
  // Brand (taken from the Pintig logo)
  static const Color crimson = Color(0xFFC81E2B);
  static const Color pintigCrimsonDark = Color(0xFF991B1B);
  static const Color pintigCoral = Color(0xFFEF4444); // the logo's centre dot
  static const Color logoIvory = Color(0xFFFAF8F5); // the logo's canvas

  // Neutrals
  static const Color ink = Color(0xFF14202B);
  static const Color paper = Color(0xFFF3F5F6);
  static const Color line = Color(0xFFE3E8EB);
  static const Color fieldBorder = Color(0xFF8A99A5);
  static const Color mutedText = Color(0xFF4A5966);
  static const Color hintText = Color(0xFF5E6D79);

  // Status. Tints carry dark text; solid colours carry white text (all >= 4.5:1).
  static const Color sea = Color(0xFF0B6E74);
  static const Color seaTint = Color(0xFFDDF0F1);
  static const Color seaInk = Color(0xFF084F54);
  static const Color amber = Color(0xFFB45309);
  static const Color amberTint = Color(0xFFFFF0CF);
  static const Color amberInk = Color(0xFF5C3A00);
  static const Color roseTint = Color(0xFFFCE8EA);
  static const Color roseInk = Color(0xFF8E1621);

  // Legacy names, kept so existing code keeps compiling.
  static const Color deepNavy = Color(0xFF0F172A);
  static const Color slateNavy = Color(0xFF1E293B);
  static const Color primaryBlue = crimson; // historical name, it is the brand crimson
  static const Color clinicalGreen = sea;
  static const Color clinicalRed = crimson;
  static const Color clinicalAmber = amber;
  static const Color surfaceBackground = paper;
  static const Color cardBorder = line;
  static const Color textPrimary = ink;
  static const Color textMuted = mutedText;

  // Ergonomic dimensions
  static const double minTouchTarget = 52.0;
  static const double inputRadius = 12.0;
  static const String fontFamily = 'AtkinsonHyperlegible';
}

class PintigTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: PintigTokens.crimson,
      primary: PintigTokens.crimson,
      surface: PintigTokens.paper,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: PintigTokens.fontFamily,
      scaffoldBackgroundColor: PintigTokens.paper,
      colorScheme: scheme,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: const TextStyle(
          fontFamily: PintigTokens.fontFamily,
          fontSize: 16.0,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: PintigTokens.ink,
          selectedBackgroundColor: PintigTokens.ink,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: PintigTokens.fieldBorder, width: 1.5),
          textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// The Pintig mark (cropped from the official logo) on the logo's own ivory.
class PintigBrandLogo extends StatelessWidget {
  final double size;
  final bool showGlow;

  const PintigBrandLogo({
    super.key,
    this.size = 48.0,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Pintig',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: PintigTokens.logoIvory,
          borderRadius: BorderRadius.circular(size * 0.26),
          border: Border.all(color: PintigTokens.line, width: 1.0),
          boxShadow: showGlow
              ? [
                  BoxShadow(
                    color: PintigTokens.crimson.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.26),
          child: Padding(
            padding: EdgeInsets.all(size * 0.04),
            child: Image.asset(
              'assets/pintig_mark.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/pintig_logo.png', fit: BoxFit.contain);
              },
            ),
          ),
        ),
      ),
    );
  }
}
