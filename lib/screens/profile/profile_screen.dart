import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/glass_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ValueNotifier<int> _sectionNotifier = ValueNotifier(0);
  late final Map<String, Product> _productMap;

  @override
  void initState() {
    super.initState();
    _productMap = {
      for (final product in MockData.products()) product.id: product
    };
  }

  @override
  void dispose() {
    _sectionNotifier.dispose();
    super.dispose();
  }

  void _onNavigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.offers);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(AppRoutes.wanted);
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppState.of(context);
    final lang = LanguageManager.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('profile')),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 3,
        onTap: _onNavigate,
      ),
      body: ValueListenableBuilder<UserSession?>(
        valueListenable: app.sessionNotifier,
        builder: (context, session, _) {
          final user = session ??
              UserSession(
                id: 'guest',
                name: lang.t('guest'),
                email: 'guest@souqbid.app',
                avatar: 'https://api.dicebear.com/7.x/initials/svg?seed=guest',
                rating: 0,
                isGuest: true,
              );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassContainer(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star_rounded,
                                    color: theme.colorScheme.primary),
                                const SizedBox(width: 4),
                                Text(user.rating.toStringAsFixed(1)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: user.isGuest
                            ? () {}
                            : () {
                                app.setSession(null);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoutes.auth,
                                  (route) => false,
                                );
                              },
                        child: Text(user.isGuest
                            ? lang.t('continue_guest')
                            : lang.t('logout')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: app.themeNotifier,
                  builder: (context, mode, __) {
                    final isDark = mode == ThemeMode.dark;
                    return SwitchListTile.adaptive(
                      title: Text(lang.t('dark_mode')),
                      value: isDark,
                      onChanged: (value) {
                        app.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                    );
                  },
                ),
                ValueListenableBuilder<Locale>(
                  valueListenable: app.localeNotifier,
                  builder: (context, locale, __) {
                    return ListTile(
                      title: Text(lang.t('language')),
                      trailing: DropdownButton<Locale>(
                        value: locale,
                        onChanged: (value) {
                          if (value != null) {
                            app.setLocale(value);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                          DropdownMenuItem(value: Locale('en'), child: Text('English')),
                        ],
                      ),
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: app.notificationsNotifier,
                  builder: (context, value, __) {
                    return SwitchListTile.adaptive(
                      title: Text(lang.t('notifications')),
                      value: value,
                      onChanged: app.setNotificationsEnabled,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<int>(
                  valueListenable: _sectionNotifier,
                  builder: (context, section, _) {
                    return SegmentedButton<int>(
                      segments: [
                        ButtonSegment(
                          value: 0,
                          label: Text(lang.t('bids')),
                        ),
                        ButtonSegment(
                          value: 1,
                          label: Text(lang.t('purchases')),
                        ),
                        ButtonSegment(
                          value: 2,
                          label: Text(lang.t('favorites')),
                        ),
                        ButtonSegment(
                          value: 3,
                          label: Text(lang.t('settings')),
                        ),
                      ],
                      selected: {section},
                      onSelectionChanged: (value) =>
                          _sectionNotifier.value = value.first,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<int>(
                  valueListenable: _sectionNotifier,
                  builder: (context, section, _) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildSection(context, section),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    int section,
  ) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);
    final app = AppState.of(context);

    switch (section) {
      case 0:
        return GlassContainer(
          key: const ValueKey('bids'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang.t('no_bids'), style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                lang.t('pull_to_refresh'),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      case 1:
        return GlassContainer(
          key: const ValueKey('purchases'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SouqBid Studio', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                lang.t('no_offers'),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      case 2:
        return ValueListenableBuilder<Set<String>>(
          key: const ValueKey('favorites'),
          valueListenable: app.favoritesNotifier,
          builder: (context, favorites, _) {
            if (favorites.isEmpty) {
              return GlassContainer(
                child: Text(lang.t('no_favorites')),
              );
            }
            return Column(
              children: favorites.map((id) {
                final product = _productMap[id];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassContainer(
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(product?.title ?? id),
                        ),
                        IconButton(
                          onPressed: () => app.toggleFavorite(id),
                          icon: Icon(Icons.delete_outline,
                              color: theme.colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      default:
        return GlassContainer(
          key: const ValueKey('settings'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang.t('session_restored'),
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('${lang.t('home')} • ${lang.t('offers')} • ${lang.t('wanted')}'),
            ],
          ),
        );
    }
  }
}
