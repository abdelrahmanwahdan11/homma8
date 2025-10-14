import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class GuestGate extends StatelessWidget {
  const GuestGate({super.key, required this.onGuest});

  final Future<void> Function() onGuest;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onGuest,
        icon: const Icon(Icons.login),
        label: Text(l10n.continueAsGuest),
      ),
    );
  }
}
