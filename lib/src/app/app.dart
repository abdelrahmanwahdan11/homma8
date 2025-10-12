import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/app_scope.dart';
import '../core/app_state.dart';
import 'router.dart';
import 'theme.dart';

class BentoBidApp extends StatelessWidget {
  const BentoBidApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(state);
    return AppScope(
      state: state,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router.config,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: state.themeMode,
        locale: state.locale,
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      ),
    );
  }
}
