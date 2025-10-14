import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bazaarx/core/app_state/app_state.dart';
import 'package:bazaarx/data/mock/seed.dart';
import 'package:bazaarx/widgets/auction_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('favorites persist locally', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();
    final auction = MockSeed.auctions().first;

    await tester.pumpWidget(MaterialApp(
      home: AppStateScope(
        notifier: appState,
        child: Scaffold(body: AuctionCard(auction: auction, appState: appState)),
      ),
    ));

    expect(appState.favoritesNotifier.value.contains(auction.id), isFalse);
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pump();
    expect(appState.favoritesNotifier.value.contains(auction.id), isTrue);
  });
}
