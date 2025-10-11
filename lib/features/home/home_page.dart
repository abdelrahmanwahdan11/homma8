import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/router.dart';
import '../../app/strings.dart';
import '../../core/design_tokens.dart';
import '../auctions/auctions_page.dart';
import '../howto/app_tour.dart';
import '../profile/profile_page.dart';
import '../sell/sell_page.dart';
import '../swipe/swipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final swipeAreaKey = GlobalKey();
  static final bidButtonKey = GlobalKey();
  static final discountBadgeKey = GlobalKey();
  static final sellTabKey = GlobalKey();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  void _startTour() {
    final context = HomePage.swipeAreaKey.currentContext;
    if (context == null) return;
    final strings = AppStrings.of(context);
    final tour = AppTour(context: context, steps: [
      TourStep(key: HomePage.swipeAreaKey, message: strings.t('howto_step_swipe')),
      TourStep(key: HomePage.bidButtonKey, message: strings.t('howto_step_bid')),
      TourStep(key: HomePage.discountBadgeKey, message: strings.t('howto_step_discount')),
      TourStep(key: HomePage.sellTabKey, message: strings.t('howto_step_sell')),
    ]);
    tour.start();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final tabs = [
      SwipePage(
        swipeKey: HomePage.swipeAreaKey,
        bidButtonKey: HomePage.bidButtonKey,
        discountBadgeKey: HomePage.discountBadgeKey,
      ),
      const AuctionsPage(),
      SellPage(initialTab: SellTab.sell, tabKey: HomePage.sellTabKey),
      const ProfilePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(RouteNames.howTo);
              if (result == true) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _startTour());
              }
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Durations.defaultDuration,
        child: tabs[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.style),
            label: strings.t('tab_swipe'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.gavel),
            label: strings.t('tab_auctions'),
          ),
          BottomNavigationBarItem(
            icon: KeyedSubtree(
              key: HomePage.sellTabKey,
              child: const Icon(Icons.sell),
            ),
            label: strings.t('tab_sell'),
            tooltip: strings.t('tab_sell'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: strings.t('tab_profile'),
          ),
        ],
      ),
    );
  }
}
