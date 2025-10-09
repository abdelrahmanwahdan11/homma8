import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_state.dart';
import 'core/localization/language_manager.dart';
import 'core/routes/app_router.dart';
import 'core/theme/theme_manager.dart';
import 'services/shared_prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPrefsService.getInstance();
  runApp(SouqBidApp(prefs: prefs));
}

class SouqBidApp extends StatelessWidget {
  const SouqBidApp({required this.prefs, super.key});

  final SharedPrefsService prefs;

  @override
  Widget build(BuildContext context) {
    return AppState(
      prefs: prefs,
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  String _resolveInitialRoute(dynamic scope) {
    final session = scope.sessionNotifier.value;
    final stored = scope.lastRouteNotifier.value;
    if (session == null) {
      return AppRoutes.onboarding;
    }
    if (stored == AppRoutes.onboarding || stored == AppRoutes.auth) {
      return AppRoutes.home;
    }
    return stored;
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppState.of(context);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: scope.themeNotifier,
      builder: (context, mode, _) {
        return LanguageManager(
          notifier: scope.localeNotifier,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SouqBid',
            theme: ThemeManager.buildLightTheme(),
            darkTheme: ThemeManager.buildDarkTheme(),
            themeMode: mode,
            locale: scope.localeNotifier.value,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: AppRouter.onGenerateRoute,
            navigatorObservers: [RouteTracker(scope.setLastRoute)],
            builder: (context, child) {
              final lang = LanguageManager.of(context);
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: const TextScaler.linear(1),
                ),
                child: Directionality(
                  textDirection: lang.direction,
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            initialRoute: _resolveInitialRoute(scope),
          ),
        );
      },
    );
  }
}
