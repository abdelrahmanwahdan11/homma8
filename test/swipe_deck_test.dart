import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bentobid/src/core/widgets/swipe_deck.dart';

void main() {
  testWidgets('controller advances index after action', (tester) async {
    final controller = SwipeDeckController();
    final actions = <SwipeDeckAction>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SwipeDeck(
          itemCount: 3,
          controller: controller,
          onAction: (action, index) => actions.add(action),
          cardBuilder: (context, index) => Container(color: Colors.blue),
        ),
      ),
    ));

    expect(controller.currentIndex, 0);
    controller.act(SwipeDeckAction.like);
    await tester.pumpAndSettle();
    expect(controller.currentIndex, 1);
    expect(actions, [SwipeDeckAction.like]);
  });
}
