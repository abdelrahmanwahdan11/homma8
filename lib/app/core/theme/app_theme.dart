import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Builds light and dark Material 3 themes inspired by the brief.
class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFFA25AC3),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE7D6F3),
      onPrimaryContainer: const Color(0xFF2F1A46),
      secondary: const Color(0xFF9FDCE2),
      onSecondary: const Color(0xFF0F2E30),
      secondaryContainer: const Color(0xFFCDEFF2),
      onSecondaryContainer: const Color(0xFF113638),
      tertiary: const Color(0xFFFECF0F),
      onTertiary: const Color(0xFF221B00),
      tertiaryContainer: const Color(0xFFFFE18F),
      onTertiaryContainer: const Color(0xFF201600),
      error: const Color(0xFFE53935),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      background: const Color(0xFFF4EEF6),
      onBackground: const Color(0xFF0F0F12),
      surface: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF17171B),
      surfaceVariant: const Color(0xFFF7F2FA),
      onSurfaceVariant: const Color(0xFF3E3E46),
      outline: const Color.fromRGBO(15, 15, 18, 0.08),
      shadow: Colors.black.withOpacity(0.16),
      scrim: Colors.black54,
      inverseSurface: const Color(0xFF2F2F35),
      onInverseSurface: const Color(0xFFF4EEF6),
      inversePrimary: const Color(0xFF6D3D8F),
      surfaceTint: const Color(0xFFA25AC3),
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFC79AE6),
      onPrimary: const Color(0xFF311848),
      primaryContainer: const Color(0xFF3B2B4C),
      onPrimaryContainer: const Color(0xFFEEDCFF),
      secondary: const Color(0xFF9ADFE5),
      onSecondary: const Color(0xFF00363A),
      secondaryContainer: const Color(0xFF1C4C51),
      onSecondaryContainer: const Color(0xFFBBEEF2),
      tertiary: const Color(0xFFFFD85A),
      onTertiary: const Color(0xFF382B00),
      tertiaryContainer: const Color(0xFF4F3F00),
      onTertiaryContainer: const Color(0xFFFFEEA9),
      error: const Color(0xFFFF6B6B),
      onError: const Color(0xFF680010),
      errorContainer: const Color(0xFF93001B),
      onErrorContainer: const Color(0xFFFFDAD6),
      background: const Color(0xFF0E0E12),
      onBackground: const Color(0xFFF2F2F3),
      surface: const Color(0xFF141419),
      onSurface: const Color(0xFFE9E9EE),
      surfaceVariant: const Color(0xFF1B1B22),
      onSurfaceVariant: const Color(0xFFB2B2C0),
      outline: const Color.fromRGBO(255, 255, 255, 0.09),
      shadow: Colors.black.withOpacity(0.6),
      scrim: Colors.black87,
      inverseSurface: const Color(0xFFE4E1EC),
      onInverseSurface: const Color(0xFF16161A),
      inversePrimary: const Color(0xFF9F7BC7),
      surfaceTint: const Color(0xFFC79AE6),
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData _baseTheme(ColorScheme scheme) {
    final textTheme = GoogleFonts.urbanistTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.background,
      fontFamily: GoogleFonts.urbanist().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface.withOpacity(0.9),
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      cardTheme: CardTheme(
        color: scheme.surface.withOpacity(0.75),
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: scheme.surface.withOpacity(0.9),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: scheme.surfaceVariant.withOpacity(0.7),
        labelStyle: textTheme.labelLarge?.copyWith(color: scheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface.withOpacity(0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outline.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outline.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary),
        ),
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface.withOpacity(0.5),
        selectedIconTheme: IconThemeData(color: scheme.primary, size: 26),
        unselectedIconTheme: IconThemeData(color: scheme.onSurface.withOpacity(0.7)),
        selectedLabelTextStyle:
            textTheme.labelLarge?.copyWith(color: scheme.primary),
        unselectedLabelTextStyle:
            textTheme.labelLarge?.copyWith(color: scheme.onSurface.withOpacity(0.7)),
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: scheme.surface.withOpacity(0.9)),
      extensions: <ThemeExtension<dynamic>>[
        GlassTheme(
          glassTint: scheme.brightness == Brightness.light
              ? const Color.fromRGBO(255, 255, 255, 0.72)
              : const Color.fromRGBO(20, 20, 25, 0.56),
          glassShadow: scheme.shadow,
        ),
      ],
    );
  }
}

/// Helper extension to hold custom glass parameters.
class GlassTheme extends ThemeExtension<GlassTheme> {
  const GlassTheme({required this.glassTint, required this.glassShadow});

  final Color glassTint;
  final Color glassShadow;

  @override
  GlassTheme copyWith({Color? glassTint, Color? glassShadow}) => GlassTheme(
        glassTint: glassTint ?? this.glassTint,
        glassShadow: glassShadow ?? this.glassShadow,
      );

  @override
  GlassTheme lerp(ThemeExtension<GlassTheme>? other, double t) {
    if (other is! GlassTheme) return this;
    return GlassTheme(
      glassTint: Color.lerp(glassTint, other.glassTint, t) ?? glassTint,
      glassShadow: Color.lerp(glassShadow, other.glassShadow, t) ?? glassShadow,
    );
  }
}
