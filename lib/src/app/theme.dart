import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color primary = Color(0xFF34A853);
  static const Color secondary = Color(0xFFD3E3FD);
  static const Color surface = Color(0xFF0F1115);
  static const Color background = Color(0xFF0A0C10);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF0A0C10);
  static const Color onSurface = Color(0xFFE6EAF2);

  static ThemeData dark() {
    final colorScheme = const ColorScheme.dark(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      surface: surface,
      background: background,
      onSurface: onSurface,
      error: Color(0xFFEA4335),
      onError: Colors.white,
    );
    return _base(colorScheme);
  }

  static ThemeData light() {
    final colorScheme = const ColorScheme.light(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      surface: Colors.white,
      background: Colors.white,
      onSurface: Colors.black,
      error: Color(0xFFEA4335),
      onError: Colors.white,
    );
    return _base(colorScheme);
  }

  static ThemeData _base(ColorScheme scheme) {
    final textTheme = _textTheme(Typography.englishLike2021);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface.withOpacity(0.8),
        selectedColor: scheme.primary.withOpacity(0.2),
        labelStyle: textTheme.labelLarge!,
        secondaryLabelStyle: textTheme.labelLarge!,
        side: BorderSide(color: scheme.primary.withOpacity(0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.primary,
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: onPrimary),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    final body = GoogleFonts.cairoTextTheme(base);
    final display = GoogleFonts.archivoBlackTextTheme(base);
    return body.copyWith(
      displayLarge: display.displayLarge,
      displayMedium: display.displayMedium,
      displaySmall: display.displaySmall,
      headlineLarge: display.headlineLarge,
      headlineMedium: display.headlineMedium,
      headlineSmall: display.headlineSmall,
      titleLarge: display.titleLarge,
      labelLarge: body.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
