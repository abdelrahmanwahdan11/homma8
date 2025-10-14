import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bazaarx/core/app_state/app_state.dart';
import 'package:bazaarx/features/create/create_auction_wizard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create auction draft', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();

    await tester.pumpWidget(MaterialApp(
      home: AppStateScope(
        notifier: appState,
        child: const Scaffold(body: CreateAuctionWizard()),
      ),
    ));

    await tester.tap(find.text('Add placeholder image'));
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Auction');
    await tester.tap(find.text('CONTINUE'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(0), '123');
    await tester.tap(find.text('CONTINUE'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(0), 'Category');
    await tester.enterText(find.byType(TextFormField).at(1), 'Location');
    await tester.tap(find.text('Publish mock'));
    await tester.pump();

    expect(find.text('Auction draft saved (mock publish soon)'), findsOneWidget);
  });
}
