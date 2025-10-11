import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/adaptive_scaffold.dart';
import '../account/account_page.dart';
import '../add/add_page.dart';
import '../browse/browse_page.dart';
import '../requests/requests_page.dart';
import '../wishes/wishes_page.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = <Widget>[
      const BrowsePage(),
      const WishesPage(),
      const RequestsPage(),
      const AddPage(),
      const AccountPage(),
    ];
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.local_offer_outlined),
        selectedIcon: const Icon(Icons.local_offer),
        label: Text(l10n.browse),
      ),
      NavigationDestination(
        icon: const Icon(Icons.favorite_outline),
        selectedIcon: const Icon(Icons.favorite),
        label: Text(l10n.wishes),
      ),
      NavigationDestination(
        icon: const Icon(Icons.shopping_bag_outlined),
        selectedIcon: const Icon(Icons.shopping_bag),
        label: Text(l10n.requests),
      ),
      NavigationDestination(
        icon: const Icon(Icons.add_box_outlined),
        selectedIcon: const Icon(Icons.add_box),
        label: Text(l10n.add),
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(l10n.account),
      ),
    ];
    return AdaptiveScaffold(
      destinations: destinations,
      index: index,
      onIndexChanged: (value) => setState(() => index = value),
      body: pages[index],
    );
  }
}
