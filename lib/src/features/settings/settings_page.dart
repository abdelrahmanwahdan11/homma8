import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/app_scope.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l10n = AppLocalizations.of(context)!;
    final localeValue = app.locale?.languageCode ?? 'system';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: localeValue,
              onChanged: (value) {
                switch (value) {
                  case 'ar':
                    app.setLocale(const Locale('ar'));
                    break;
                  case 'en':
                    app.setLocale(const Locale('en'));
                    break;
                  default:
                    app.setLocale(null);
                }
              },
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(value: 'system', child: Text('System')),
                DropdownMenuItem<String>(value: 'ar', child: Text('العربية')),
                DropdownMenuItem<String>(value: 'en', child: Text('English')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: Text(l10n.theme),
            subtitle: Text(app.themeMode.name),
            trailing: SegmentedButton<ThemeMode>(
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.settings_suggest),
                ),
              ],
              selected: <ThemeMode>{app.themeMode},
              onSelectionChanged: (selection) => app.setThemeMode(selection.first),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('الإشعارات'),
            subtitle: const Text('مصفوفة القنوات/الفئات (محاكاة)'),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('الإشعارات'),
                  content: const Text('صفحة إعدادات إشعارات محاكاة'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('منطقة الخطر'),
              subtitle: const Text('تعطيل/حذف الحساب'),
              trailing: const Icon(Icons.warning_amber),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⚠ إجراء خطِر (محاكاة)')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
