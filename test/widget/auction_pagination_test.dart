import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bazaarx/core/app_state/app_state.dart';
import 'package:bazaarx/features/home/auctions_tab.dart';
import 'package:bazaarx/widgets/auction_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('auction pagination loads items', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();

    await tester.pumpWidget(MaterialApp(
      home: AppStateScope(
        notifier: appState,
        child: const Scaffold(body: AuctionsTab(query: '')),
      ),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(AuctionCard), findsWidgets);
  });
}
