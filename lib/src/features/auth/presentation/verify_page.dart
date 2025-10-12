import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.verifyNow)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, size: 96, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text('A verification code has been sent to your email.', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  final state = AppScope.of(context);
                  state.login(state.user.email, 'verified');
                  AppRouterDelegate.of(context).go('/swipe');
                },
                child: Text(l10n.verifyNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
