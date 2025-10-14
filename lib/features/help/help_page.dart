import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ExpansionTile(
            title: Text('How to place a bid?'),
            children: [Text('Open an auction, tap place bid, confirm mock bid.')],
          ),
          ExpansionTile(
            title: Text('How to add wanted post?'),
            children: [Text('Navigate to create tab and fill the wanted wizard.')],
          ),
          ListTile(
            leading: Icon(Icons.contact_support_outlined),
            title: Text('Contact support (placeholder)'),
          ),
        ],
      ),
    );
  }
}
