import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../data/repos/repo_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onOpenPrefs});

  final VoidCallback onOpenPrefs;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final user = appState.isGuest ? RepoProvider.userRepository.guest : RepoProvider.userRepository.guest;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(radius: 44, child: Text(user.name[0])),
          const SizedBox(height: 12),
          Text(user.name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(appState.isGuest ? 'Guest session' : 'Member', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Preferences'),
            onTap: onOpenPrefs,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Notification settings coming soon'))),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Logout mock (stay guest)'))),
          ),
        ],
      ),
    );
  }
}
