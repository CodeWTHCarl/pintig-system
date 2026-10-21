// lib/presentation/theme/pintig_tokens.dart
import 'package:flutter/material.dart';

class PintigTokens {
  // UI/UX Pro Max Brand Palette (Derived from Pintig Monogram Logo)
  static const Color deepNavy = Color(0xFF0F172A);
  static const Color slateNavy = Color(0xFF1E293B);
  static const Color primaryBlue = Color(0xFFC81E2B); // Pintig Arterial Crimson
  static const Color pintigCrimsonDark = Color(0xFF991B1B);
  static const Color pintigCoral = Color(0xFFEF4444); // Logo Center Pulse Dot
  static const Color logoIvory = Color(0xFFFAF8F5);   // Logo Alabaster Canvas

  // Clinical Triage Semantic Colors
  static const Color clinicalGreen = Color(0xFF059669);
  static const Color clinicalRed = Color(0xFFE11D48);
  static const Color clinicalAmber = Color(0xFFD97706);

  // Surface & Typography Tokens
  static const Color surfaceBackground = Color(0xFFF8FAFC);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  // Ergonomic Dimensions
  static const double minTouchTarget = 52.0;
  static const double inputRadius = 12.0;
}

/// Official Pintig Brand Emblem Widget (Loads assets/pintig_logo.png with vector fallback)
class PintigBrandLogo extends StatelessWidget {
  final double size;
  final bool showGlow;

  const PintigBrandLogo({
    super.key,
    this.size = 48.0,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.08),
      decoration: BoxDecoration(
        color: PintigTokens.logoIvory,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 1.5,
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: PintigTokens.primaryBlue.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.asset(
          'assets/pintig_logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return CustomPaint(
              painter: _PintigMonogramFallbackPainter(),
            );
          },
        ),
      ),
    );
  }
}

class _PintigMonogramFallbackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final loopPaint = Paint()
      ..color = PintigTokens.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(w * 0.35, h * 0.82)
      ..lineTo(w * 0.35, h * 0.32)
      ..arcToPoint(
        Offset(w * 0.78, h * 0.45),
        radius: Radius.circular(w * 0.24),
        clockwise: true,
      )
      ..arcToPoint(
        Offset(w * 0.35, h * 0.62),
        radius: Radius.circular(w * 0.24),
        clockwise: true,
      );

    canvas.drawPath(path, loopPaint);

    final dotPaint = Paint()
      ..color = PintigTokens.pintigCoral
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.52, h * 0.48), w * 0.08, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}