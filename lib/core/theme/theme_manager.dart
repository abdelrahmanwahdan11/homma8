import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager extends InheritedWidget {
  const ThemeManager({
    required this.themeNotifier,
    required this.useSystemThemeNotifier,
    required super.child,
    super.key,
  });

  final ValueNotifier<ThemeMode> themeNotifier;
  final ValueNotifier<bool> useSystemThemeNotifier;

  static ThemeManager of(BuildContext context) {
    final manager =
        context.dependOnInheritedWidgetOfExactType<ThemeManager>();
    assert(manager != null, 'ThemeManager not found in context');
    return manager!;
  }

  void toggleTheme() {
    if (useSystemThemeNotifier.value) {
      useSystemThemeNotifier.value = false;
    }
    themeNotifier.value =
        themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setUseSystemTheme(bool enabled) {
    useSystemThemeNotifier.value = enabled;
  }

  @override
  bool updateShouldNotify(covariant ThemeManager oldWidget) {
    return oldWidget.themeNotifier != themeNotifier ||
        oldWidget.useSystemThemeNotifier != useSystemThemeNotifier;
  }

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        background: const [Color(0xFFF4EEF6), Color(0xFFE7E0EC)],
        surface: const [Color(0xFFFFFFFF), Color(0xFFF5EDF9)],
        primary: const [Color(0xFFA25AC3), Color(0xFF9FDCE2)],
        accent: const [Color(0xFFFECF0F), Color(0xFFF8E37B)],
        text: const Color(0xFF0F0F12),
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        background: const [Color(0xFF0E0E12), Color(0xFF1B1B22)],
        surface: const [Color(0xFF141419), Color(0xFF1F1F27)],
        primary: const [Color(0xFFC79AE6), Color(0xFF9ADFE5)],
        accent: const [Color(0xFFFFD85A), Color(0xFFF9CA4F)],
        text: const Color(0xFFF2F2F3),
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required List<Color> background,
    required List<Color> surface,
    required List<Color> primary,
    required List<Color> accent,
    required Color text,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary.first,
      onPrimary: Colors.white,
      secondary: primary.last,
      onSecondary: brightness == Brightness.light ? Colors.black : Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      background: background.first,
      onBackground: text,
      surface: surface.first,
      onSurface: text,
    );

    final baseTextTheme = GoogleFonts.urbanistTextTheme();
    final textTheme = baseTextTheme.apply(
      bodyColor: text,
      displayColor: text,
    );

    final gradients = AppGradients(
      background: LinearGradient(
        colors: background,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      surface: LinearGradient(
        colors: surface,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      primary: LinearGradient(
        colors: primary,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accent: LinearGradient(
        colors: accent,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: surface.first.withOpacity(0.65),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: primary.first.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: primary.first.withOpacity(0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: primary.first),
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(color: text.withOpacity(0.75)),
      hintStyle: textTheme.bodyMedium?.copyWith(color: text.withOpacity(0.5)),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle:
            textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardTheme(
        color: surface.first.withOpacity(0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary.first,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primary.last.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        labelStyle: textTheme.labelLarge,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surface.first.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeScalePageTransitionBuilder(),
          TargetPlatform.iOS: _FadeScalePageTransitionBuilder(),
          TargetPlatform.fuchsia: _FadeScalePageTransitionBuilder(),
          TargetPlatform.macOS: _FadeScalePageTransitionBuilder(),
          TargetPlatform.windows: _FadeScalePageTransitionBuilder(),
          TargetPlatform.linux: _FadeScalePageTransitionBuilder(),
        },
      ),
      extensions: <ThemeExtension<dynamic>>[gradients],
    );
  }
}

class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    required this.background,
    required this.surface,
    required this.primary,
    required this.accent,
  });

  final LinearGradient background;
  final LinearGradient surface;
  final LinearGradient primary;
  final LinearGradient accent;

  @override
  AppGradients copyWith({
    LinearGradient? background,
    LinearGradient? surface,
    LinearGradient? primary,
    LinearGradient? accent,
  }) {
    return AppGradients(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) {
      return this;
    }
    return AppGradients(
      background: LinearGradient.lerp(background, other.background, t)!,
      surface: LinearGradient.lerp(surface, other.surface, t)!,
      primary: LinearGradient.lerp(primary, other.primary, t)!,
      accent: LinearGradient.lerp(accent, other.accent, t)!,
    );
  }
}

class _FadeScalePageTransitionBuilder extends PageTransitionsBuilder {
  const _FadeScalePageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutQuad);
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
        child: child,
      ),
    );
  }
}
