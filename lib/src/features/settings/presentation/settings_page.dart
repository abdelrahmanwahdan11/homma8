import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_scope.dart';
import '../../../core/app_state.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../models/models.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserPrefs _prefs;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _prefs = AppScope.of(context).user.prefs;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            value: state.themeMode == ThemeMode.dark,
            onChanged: (value) => state.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
            title: Text(l10n.darkMode),
          ),
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(state.locale.languageCode),
            onTap: () => _openLanguageSheet(context, state),
          ),
          ListTile(
            title: Text(l10n.favCategories),
            subtitle: Text(_prefs.favCategories.join(', ')),
            onTap: () => _openCategoriesSheet(context, state),
          ),
          ListTile(
            title: Text(l10n.priceRange),
            subtitle: Text('${_prefs.priceMin ?? 0} - ${_prefs.priceMax ?? 0}'),
            onTap: () => _openPriceSheet(context, state),
          ),
          ListTile(
            title: Text(l10n.referralCode),
            subtitle: SelectableText(state.ensureReferralCode()),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => Clipboard.setData(ClipboardData(text: state.ensureReferralCode())),
            ),
          ),
          ListTile(
            title: Text(l10n.logout),
            onTap: () => state.logout(),
          ),
        ],
      ),
    );
  }

  Future<void> _openLanguageSheet(BuildContext context, AppState state) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                state.setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                state.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _openCategoriesSheet(BuildContext context, AppState state) async {
    final categories = state.items.map((item) => item.category).toSet();
    final selected = Set<String>.from(_prefs.favCategories);
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final category in categories)
                  CheckboxListTile(
                    title: Text(category),
                    value: selected.contains(category),
                    onChanged: (value) {
                      setModalState(() {
                        if (value == true) {
                          selected.add(category);
                        } else {
                          selected.remove(category);
                        }
                      });
                    },
                  ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _prefs = _prefs.copyWith(favCategories: selected.toList());
                      state.updatePreferences(_prefs);
                    });
                  },
                  child: Text(context.l10n.save),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openPriceSheet(BuildContext context, AppState state) async {
    double min = _prefs.priceMin ?? 0;
    double max = _prefs.priceMax ?? 2000;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RangeSlider(
                  min: 0,
                  max: 5000,
                  values: RangeValues(min, max),
                  onChanged: (value) => setModalState(() {
                    min = value.start;
                    max = value.end;
                  }),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _prefs = _prefs.copyWith(priceMin: min, priceMax: max);
                      state.updatePreferences(_prefs);
                    });
                  },
                  child: Text(context.l10n.save),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
