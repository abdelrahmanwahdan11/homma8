import 'package:flutter/material.dart';

class GuestGate extends StatelessWidget {
  const GuestGate({super.key, required this.onGuest});

  final Future<void> Function() onGuest;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onGuest,
        icon: const Icon(Icons.login),
        label: const Text('Continue as guest'),
      ),
    );
  }
}
