import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _accentLime = Color(0xFFECF224);
  static const _accentDark = Color(0xFF3D4142);
  static const _backgroundLight = Color(0xFFDEDEDE);
  static const _surfaceLight = Color(0xFFE0E0E0);
  static const _surfaceAltLight = Color(0xFFA7A7A2);
  static const _textPrimaryLight = Color(0xFF191A19);
  static const _textSecondaryLight = Color(0xFF5B5C5C);
  static const _dividerLight = Color(0xFFC1C1BC);

  static const _backgroundDark = Color(0xFF1A1A19);
  static const _surfaceDark = Color(0xFF3D4142);
  static const _surfaceAltDark = Color(0xFF5B5C5C);
  static const _textPrimaryDark = Color(0xFFDEDEDE);
  static const _textSecondaryDark = Color(0xFFC1C1BC);
  static const _dividerDark = Color(0xFF5B5C5C);

  static ThemeData lightTheme(Brightness platformBrightness) {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = _typography(base.textTheme);
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: _backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: _accentLime,
        primary: _accentLime,
        secondary: _accentDark,
        surface: _surfaceLight,
        background: _backgroundLight,
        onSurface: _textPrimaryLight,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceLight,
        elevation: 0,
        foregroundColor: _textPrimaryLight,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerColor: _dividerLight,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surfaceLight,
        selectedItemColor: _accentLime,
        unselectedItemColor: _textSecondaryLight,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFC4C5BD),
        selectedColor: _accentLime,
        labelStyle: textTheme.bodyMedium?.copyWith(color: _textPrimaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _accentDark,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: _FadePageTransitionBuilder(),
        TargetPlatform.iOS: _FadePageTransitionBuilder(),
        TargetPlatform.macOS: _FadePageTransitionBuilder(),
        TargetPlatform.linux: _FadePageTransitionBuilder(),
        TargetPlatform.windows: _FadePageTransitionBuilder(),
      }),
      visualDensity: VisualDensity.standard,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.92),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _accentDark, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = _typography(base.textTheme, isDark: true);
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: _accentLime,
        primary: _accentLime,
        secondary: _accentDark,
        surface: _surfaceDark,
        background: _backgroundDark,
        onSurface: _textPrimaryDark,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceDark,
        elevation: 0,
        foregroundColor: _textPrimaryDark,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardTheme(
        color: _surfaceDark,
        elevation: 2,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerColor: _dividerDark,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surfaceDark,
        selectedItemColor: _accentLime,
        unselectedItemColor: _textSecondaryDark,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF5B5C5C),
        selectedColor: _accentLime,
        labelStyle: textTheme.bodyMedium?.copyWith(color: _textPrimaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _accentDark,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceAltDark.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _accentLime, width: 1.5),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: _FadePageTransitionBuilder(),
        TargetPlatform.iOS: _FadePageTransitionBuilder(),
        TargetPlatform.macOS: _FadePageTransitionBuilder(),
        TargetPlatform.linux: _FadePageTransitionBuilder(),
        TargetPlatform.windows: _FadePageTransitionBuilder(),
      }),
    );
  }

  static TextTheme _typography(TextTheme base, {bool isDark = false}) {
    final font = GoogleFonts.getFont('Space Mono');
    return TextTheme(
      displayLarge: font.copyWith(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: 0.4),
      titleLarge: font.copyWith(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.2),
      bodyLarge: font.copyWith(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      bodyMedium: font.copyWith(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      bodySmall: font.copyWith(fontSize: 12, fontWeight: FontWeight.w300, letterSpacing: 0.1),
      labelLarge: font.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    ).apply(
      bodyColor: isDark ? _textPrimaryDark : _textPrimaryLight,
      displayColor: isDark ? _textPrimaryDark : _textPrimaryLight,
    );
  }
}

class _FadePageTransitionBuilder extends PageTransitionsBuilder {
  const _FadePageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
      child: child,
    );
  }
}
