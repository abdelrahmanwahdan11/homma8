import 'package:flutter/material.dart';

import '../core/localization/language_manager.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          label: lang.t('home'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.local_offer_outlined),
          label: lang.t('offers'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.list_alt_outlined),
          label: lang.t('wanted'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          label: lang.t('profile'),
        ),
      ],
    );
  }
}
