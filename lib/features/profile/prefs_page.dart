import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/localization/app_localizations.dart';

class PrefsPage extends StatelessWidget {
  const PrefsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final l10n = context.l10n;
    String labelForLocale(Locale locale) {
      switch (locale.languageCode) {
        case 'ar':
          return l10n.arabic;
        case 'en':
        default:
          return l10n.english;
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.preferences)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(l10n.darkMode),
            value: appState.themeMode == ThemeMode.dark,
            onChanged: (value) => appState.updateThemeMode(value ? ThemeMode.dark : ThemeMode.light),
          ),
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<Locale>(
              value: appState.localeOverride,
              hint: Text(l10n.systemDefault),
              items: AppLocalizations.supportedLocales
                  .map((locale) => DropdownMenuItem(value: locale, child: Text(labelForLocale(locale))))
                  .toList(),
              onChanged: (locale) => appState.updateLocale(locale),
            ),
          ),
        ],
      ),
    );
  }
}
