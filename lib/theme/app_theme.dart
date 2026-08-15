import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette
  static const Color deepPurple = Color(0xFF6C63FF);
  static const Color vibrantPink = Color(0xFFFF6B9A);
  static const Color warmSunburstYellow = Color(0xFFFFD166);
  static const Color deepNavy = Color(0xFF1F2937);

  static const Color ctaOrange = Color(0xFFFF8E53);

  // Status Indicators
  static const Color statusSuccess = Color(0xFF4ADE80);
  static const Color statusWarning = Color(0xFFFFB703);
  static const Color statusDanger = Color(0xFFEF4444);

  // Glassmorphism Card Fill
  static Color glassCardBackground = Colors.white.withOpacity(0.92);
  static Color glassBorderColor = Colors.white.withOpacity(0.4);

  // Background Mesh Gradient (with phase offset support)
  static LinearGradient backgroundGradient(double phase) {
    return LinearGradient(
      begin: Alignment(-1.0 + (phase * 0.4), -1.0),
      end: Alignment(1.0, 1.0 - (phase * 0.4)),
      colors: const [
        deepPurple,
        vibrantPink,
        warmSunburstYellow,
      ],
      stops: const [0.0, 0.55, 1.0],
    );
  }

  // Action CTA Button Gradient
  static const LinearGradient actionCtaGradient = LinearGradient(
    colors: [vibrantPink, ctaOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft CTA Glow Shadow
  static List<BoxShadow> ctaGlowShadow = const [
    BoxShadow(
      color: Color(0x40FF6B9A),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  // Glass Card Shadow
  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: vibrantPink,
      scaffoldBackgroundColor: Colors.transparent, // Handled by backdrop gradient
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.outfit(
          color: deepNavy,
          fontSize: 34,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          color: deepNavy,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.outfit(
          color: deepNavy,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: deepNavy,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: deepNavy.withOpacity(0.8),
          fontSize: 14,
        ),
      ),
    );
  }
}
