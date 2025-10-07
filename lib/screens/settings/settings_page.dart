import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../widgets/glass_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final state = AppState.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.t('appearance'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: state.themeNotifier,
                builder: (context, mode, _) {
                  return SwitchListTile(
                    value: mode == ThemeMode.dark,
                    onChanged: (_) => state.toggleTheme(),
                    title: Text(lang.t('dark_mode')),
                  );
                },
              ),
              const Divider(height: 32),
              Text(
                lang.t('language'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<Locale>(
                valueListenable: state.localeNotifier,
                builder: (context, locale, _) {
                  return ElevatedButton.icon(
                    onPressed: () {
                      state.switchLanguage();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(lang.t('language_switched'))),
                      );
                    },
                    icon: const Icon(Icons.language_rounded),
                    label: Text(
                      locale.languageCode == 'en' ? 'عربي' : 'English',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
