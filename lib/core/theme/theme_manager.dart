import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  ThemeManager({
    required ValueNotifier<ThemeMode> themeNotifier,
    required super.child,
    super.key,
  }) : super(notifier: themeNotifier);

  ValueNotifier<ThemeMode> get themeNotifier => notifier!;

  static ThemeManager of(BuildContext context) {
    final manager =
        context.dependOnInheritedWidgetOfExactType<ThemeManager>();
    assert(manager != null, 'ThemeManager not found in context');
    return manager!;
  }

  void toggleTheme() {
    final notifier = themeNotifier;
    notifier.value = notifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        background: const Color(0xFFF4EEF6),
        surface: const Color(0xFFFFFFFF),
        primary: const Color(0xFFA25AC3),
        secondary: const Color(0xFF9FDCE2),
        accent: const Color(0xFFFECF0F),
        text: const Color(0xFF0F0F12),
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        background: const Color(0xFF0E0E12),
        surface: const Color(0xFF141419),
        primary: const Color(0xFFC79AE6),
        secondary: const Color(0xFF9ADFE5),
        accent: const Color(0xFFFFD85A),
        text: const Color(0xFFF2F2F3),
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color secondary,
    required Color accent,
    required Color text,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: brightness == Brightness.light ? Colors.white : Colors.black,
      secondary: secondary,
      onSecondary: brightness == Brightness.light ? Colors.black : Colors.black,
      error: Colors.redAccent,
      onError: Colors.white,
      background: background,
      onBackground: text,
      surface: surface,
      onSurface: text,
    );

    final baseTextTheme = GoogleFonts.urbanistTextTheme();
    final textTheme = baseTextTheme.apply(
      bodyColor: text,
      displayColor: text,
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor:
            brightness == Brightness.light ? Colors.white : Colors.black,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );

    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        side: BorderSide(color: primary.withOpacity(0.7)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );

    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: surface.withOpacity(0.8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primary.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primary),
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: text.withOpacity(0.7),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: text.withOpacity(0.5),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle:
            textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardTheme(
        color: surface.withOpacity(0.85),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: text,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
