import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/repos/repo_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onOpenPrefs});

  final VoidCallback onOpenPrefs;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appState = AppStateScope.of(context);
    final user = appState.isGuest ? RepoProvider.userRepository.guest : RepoProvider.userRepository.guest;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(radius: 44, child: Text(user.name[0])),
          const SizedBox(height: 12),
          Text(user.name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(appState.isGuest ? l10n.guestSession : l10n.member, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.preferences),
            onTap: onOpenPrefs,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.notifications),
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.notificationSettingsSoon))),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.logoutMock))),
          ),
        ],
      ),
    );
  }
}
