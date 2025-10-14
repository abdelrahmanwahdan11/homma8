import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/search_bar.dart';
import 'auctions_tab.dart';
import 'for_you_tab.dart';
import 'wanted_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  final ValueNotifier<String> _query = ValueNotifier<String>('');

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final appState = AppStateScope.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'create_fab',
          onPressed: () => appState.bottomNavIndex.value = 2,
          child: const Icon(Icons.add),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, inner) => [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              title: Text(l10n['home']),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: BazaarSearchBar(onQueryChanged: (value) => _query.value = value),
                    ),
                    TabBar(
                      tabs: [
                        Tab(text: l10n['tab_for_you']),
                        Tab(text: l10n['tab_auctions']),
                        Tab(text: l10n['tab_wanted']),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: ValueListenableBuilder<String>(
            valueListenable: _query,
            builder: (context, query, _) {
              return TabBarView(
                children: [
                  ForYouTab(query: query, key: const PageStorageKey('for_you_tab')),
                  AuctionsTab(query: query, key: const PageStorageKey('auctions_tab')),
                  WantedTab(query: query, key: const PageStorageKey('wanted_tab')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
