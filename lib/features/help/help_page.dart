import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpFaq)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ExpansionTile(
            title: Text(l10n.faqHowBid),
            children: [Text(l10n.faqHowBidAnswer)],
          ),
          ExpansionTile(
            title: Text(l10n.faqHowWanted),
            children: [Text(l10n.faqHowWantedAnswer)],
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_outlined),
            title: Text(l10n.faqContactSupport),
          ),
        ],
      ),
    );
  }
}
