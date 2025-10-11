import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/strings.dart';
import '../../application/stores.dart';
import '../../core/design_tokens.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final current = scope.appStore.value.locale.languageCode;
                  final next = current == 'ar' ? const Locale('en') : const Locale('ar');
                  scope.appStore.setLocale(next);
                },
                child: Text(strings.t('toggle_language')),
              ),
              const SizedBox(width: Spacing.md),
              ElevatedButton(
                onPressed: () {
                  final next = scope.appStore.value.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                  scope.appStore.setThemeMode(next);
                },
                child: Text(strings.t('toggle_theme')),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          Expanded(
            child: ValueListenableBuilder<UserState>(
              valueListenable: scope.userStore,
              builder: (context, state, _) {
                return ListView(
                  children: [
                    Text(strings.t('profile_watchlist'), style: Theme.of(context).textTheme.titleLarge),
                    if (state.watchlist.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                        child: Text(strings.t('watchlist_empty')),
                      )
                    else
                      ...state.watchlist.map(
                        (product) => ListTile(
                          title: Text(product.title),
                          subtitle: Text(product.category),
                        ),
                      ),
                    const SizedBox(height: Spacing.lg),
                    Text(strings.t('profile_alerts'), style: Theme.of(context).textTheme.titleLarge),
                    if (state.alerts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                        child: Text(strings.t('alerts_empty')),
                      )
                    else
                      ...state.alerts.map(
                        (alert) => ListTile(
                          title: Text('Alert for ${alert.productId}'),
                          subtitle: Text(alert.matchedAt.toIso8601String()),
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
