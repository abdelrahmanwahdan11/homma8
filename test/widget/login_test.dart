import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bazaarx/features/auth/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login success guest', (tester) async {
    SharedPreferences.setMockInitialValues({});
    var guestCalled = false;
    await tester.pumpWidget(MaterialApp(home: AuthPage(onGuest: () async => guestCalled = true)));

    await tester.enterText(find.byType(TextFormField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(guestCalled, isTrue);
    expect(find.text('Logged in (mock)'), findsOneWidget);
  });
}
