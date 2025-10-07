import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_state.dart';
import 'core/localization/language_manager.dart';
import 'core/theme/theme_manager.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const AuctionApp());
}

class AuctionApp extends StatelessWidget {
  const AuctionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppState(
      child: Builder(
        builder: (context) {
          final state = AppState.of(context);
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: state.themeNotifier,
            builder: (context, mode, _) {
              return ValueListenableBuilder<Locale>(
                valueListenable: state.localeNotifier,
                builder: (context, locale, __) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeManager.lightTheme,
                    darkTheme: ThemeManager.darkTheme,
                    themeMode: mode,
                    locale: locale,
                    supportedLocales: const [
                      Locale('en'),
                      Locale('ar'),
                    ],
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    builder: (context, child) {
                      final lang = LanguageManager.of(context);
                      return Directionality(
                        textDirection: lang.locale.languageCode == 'ar'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: child ?? const SizedBox.shrink(),
                      );
                    },
                    onGenerateTitle: (context) =>
                        LanguageManager.of(context).t('auction_app'),
                    home: const SplashScreen(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
