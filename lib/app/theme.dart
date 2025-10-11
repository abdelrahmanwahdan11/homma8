import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/design_tokens.dart';

class GreyDegreeTheme {
  GreyDegreeTheme._();

  static const _greys = <int, Color>{
    50: Color(0xFFF2F2F2),
    100: Color(0xFFD6D6D6),
    200: Color(0xFFB0B0B0),
    300: Color(0xFF8C8C8C),
    400: Color(0xFF6B6B6B),
    500: Color(0xFF4F4F4F),
    600: Color(0xFF3A3A3A),
    700: Color(0xFF2A2A2A),
    800: Color(0xFF1E1E1E),
    900: Color(0xFF121212),
  };

  static ThemeData buildLightTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: _greys[600],
        secondary: const Color(0xFF3498DB),
        surface: Colors.white,
        background: _greys[50],
        error: const Color(0xFFE74C3C),
      ),
      scaffoldBackgroundColor: _greys[50],
      textTheme: _textTheme(brightness: Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: _greys[50],
        foregroundColor: _greys[900],
        elevation: Elevations.card,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: Elevations.card,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: Radii.medium),
        ),
      ),
      cardTheme: CardTheme(
        elevation: Elevations.card,
        shape: RoundedRectangleBorder(borderRadius: Radii.medium),
        margin: const EdgeInsets.all(Spacing.sm),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: Radii.medium),
      ),
    );
  }

  static ThemeData buildDarkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: _greys[300],
        secondary: const Color(0xFF2ECC71),
        surface: _greys[800],
        background: _greys[900],
        error: const Color(0xFFE74C3C),
      ),
      textTheme: _textTheme(brightness: Brightness.dark),
      scaffoldBackgroundColor: _greys[900],
      cardTheme: CardTheme(
        elevation: Elevations.card,
        color: _greys[800],
        shape: RoundedRectangleBorder(borderRadius: Radii.medium),
        margin: const EdgeInsets.all(Spacing.sm),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _greys[900],
        foregroundColor: Colors.white,
        elevation: Elevations.card,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _greys[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: Radii.medium),
        ),
      ),
    );
  }

  static TextTheme _textTheme({required Brightness brightness}) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    return base.apply(
      fontFamily: null,
    ).copyWith(
      displayLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      bodyLarge: GoogleFonts.poppins(fontSize: 16),
      bodyMedium: GoogleFonts.poppins(fontSize: 14),
      bodySmall: GoogleFonts.poppins(fontSize: 12),
    );
  }

  static TextStyle arabicTextStyle(TextStyle base) {
    return GoogleFonts.cairo(textStyle: base);
  }
}
