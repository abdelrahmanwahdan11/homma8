import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import 'create_auction_wizard.dart';
import 'create_wanted_wizard.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n['create']),
          bottom: const TabBar(tabs: [Tab(text: 'Auction'), Tab(text: 'Wanted')]),
        ),
        body: const TabBarView(
          children: [
            CreateAuctionWizard(),
            CreateWantedWizard(),
          ],
        ),
      ),
    );
  }
}
