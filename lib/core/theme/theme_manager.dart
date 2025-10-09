import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreyPalette {
  GreyPalette._();

  static const grey0 = Color(0xFFFAFAFA);
  static const grey1 = Color(0xFFF0F0F0);
  static const grey2 = Color(0xFFD9D9D9);
  static const grey3 = Color(0xFFBDBDBD);
  static const grey4 = Color(0xFF8C8C8C);
  static const grey5 = Color(0xFF595959);
  static const grey6 = Color(0xFF2F2F2F);
  static const inkPrimary = Color(0xFF101010);
  static const inkSecondary = Color(0xFF1C1C1C);
  static const accent = Color(0xFF7A7AFF);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const danger = Color(0xFFE53935);
}

class ThemeManager {
  static ThemeData buildLightTheme() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: GreyPalette.accent,
      onPrimary: Colors.white,
      secondary: GreyPalette.inkSecondary,
      onSecondary: Colors.white,
      error: GreyPalette.danger,
      onError: Colors.white,
      background: GreyPalette.grey1,
      onBackground: GreyPalette.inkPrimary,
      surface: GreyPalette.grey0.withOpacity(0.92),
      onSurface: GreyPalette.inkPrimary,
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData buildDarkTheme() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: GreyPalette.accent,
      onPrimary: GreyPalette.inkPrimary,
      secondary: GreyPalette.grey4,
      onSecondary: GreyPalette.inkPrimary,
      error: GreyPalette.danger,
      onError: Colors.white,
      background: GreyPalette.inkPrimary,
      onBackground: GreyPalette.grey1,
      surface: GreyPalette.inkSecondary.withOpacity(0.9),
      onSurface: GreyPalette.grey1,
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    final textTheme = GoogleFonts.urbanistTextTheme().copyWith(
      displayLarge: GoogleFonts.urbanist(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: colorScheme.onBackground,
      ),
      headlineSmall: GoogleFonts.urbanist(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      titleMedium: GoogleFonts.urbanist(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodySmall: GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface.withOpacity(0.7),
      ),
    );

    final glassBorder = BorderSide(color: colorScheme.onSurface.withOpacity(0.08));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.background.withOpacity(0.95),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onBackground,
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: glassBorder,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withOpacity(0.1),
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface.withOpacity(0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: glassBorder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: glassBorder,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shadowColor: colorScheme.primary.withOpacity(0.4),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary.withOpacity(0.12),
        secondarySelectedColor: colorScheme.primary,
        labelStyle: textTheme.bodyMedium!,
        secondaryLabelStyle: textTheme.bodyMedium!.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
    );
  }
}
