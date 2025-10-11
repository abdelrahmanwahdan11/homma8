import 'package:flutter/material.dart';

import '../../core/app_scope.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('الإعدادات'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('تسجيل الخروج'),
            onTap: () {
              app.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
