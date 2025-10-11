import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mazzzad/src/features/splash/splash_soon_page.dart';

Widget _wrap(Widget child, Locale locale) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: Directionality(
      textDirection:
          locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    ),
  );
}

void main() {
  testWidgets('shows قريباً in Arabic', (tester) async {
    await tester.pumpWidget(_wrap(const SplashSoonPage(onDone: _noop), const Locale('ar')));
    await tester.pump(const Duration(milliseconds: 16));
    expect(find.text('قريباً'), findsOneWidget);
  });

  testWidgets('shows Coming soon in English', (tester) async {
    await tester.pumpWidget(_wrap(const SplashSoonPage(onDone: _noop), const Locale('en')));
    await tester.pump(const Duration(milliseconds: 16));
    expect(find.text('Coming soon'), findsOneWidget);
  });
}

void _noop() {}
