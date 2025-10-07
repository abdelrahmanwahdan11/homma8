import 'package:flutter/material.dart';

import 'localization/language_manager.dart';
import 'theme/theme_manager.dart';

class AppState extends StatefulWidget {
  const AppState({required this.child, super.key});

  final Widget child;

  static _AppStateScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AppStateScope>();
    assert(scope != null, 'AppState not found in context');
    return scope!;
  }

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  late final ValueNotifier<ThemeMode> _themeNotifier;
  late final ValueNotifier<Locale> _localeNotifier;

  @override
  void initState() {
    super.initState();
    _themeNotifier = ValueNotifier(ThemeMode.light);
    _localeNotifier = ValueNotifier(const Locale('en'));
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    _localeNotifier.dispose();
    super.dispose();
  }

  void toggleTheme() {
    _themeNotifier.value =
        _themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void switchLanguage() {
    _localeNotifier.value =
        _localeNotifier.value.languageCode == 'en'
            ? const Locale('ar')
            : const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      themeNotifier: _themeNotifier,
      child: LanguageManager(
        localeNotifier: _localeNotifier,
        child: _AppStateScope(
          state: this,
          child: widget.child,
        ),
      ),
    );
  }
}

class _AppStateScope extends InheritedWidget {
  const _AppStateScope({required this.state, required super.child});

  final _AppStateState state;

  ValueNotifier<ThemeMode> get themeNotifier => state._themeNotifier;
  ValueNotifier<Locale> get localeNotifier => state._localeNotifier;

  void toggleTheme() => state.toggleTheme();

  void switchLanguage() => state.switchLanguage();

  @override
  bool updateShouldNotify(covariant _AppStateScope oldWidget) {
    return oldWidget.state != state;
  }
}
