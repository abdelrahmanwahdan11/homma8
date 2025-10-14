import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bazaarx/core/app_state/app_state.dart';
import 'package:bazaarx/data/mock/seed.dart';
import 'package:bazaarx/widgets/auction_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home card layout light golden', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();
    final auction = MockSeed.auctions().first;
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.light(),
      home: AppStateScope(
        notifier: appState,
        child: Scaffold(body: Center(child: SizedBox(width: 200, height: 260, child: AuctionCard(auction: auction, appState: appState)))),
      ),
    ));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/home_card_layout_light.png'),
      skip: true,
    );
  });

  testWidgets('home card layout dark golden', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();
    final auction = MockSeed.auctions()[1];
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.dark(),
      home: AppStateScope(
        notifier: appState,
        child: Scaffold(body: Center(child: SizedBox(width: 200, height: 260, child: AuctionCard(auction: auction, appState: appState)))),
      ),
    ));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/home_card_layout_dark.png'),
      skip: true,
    );
  });
}
