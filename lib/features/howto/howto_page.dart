import 'package:flutter/material.dart';

import '../../app/strings.dart';
import '../../core/design_tokens.dart';

class HowToPage extends StatelessWidget {
  const HowToPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final steps = [
      strings.t('howto_step_swipe'),
      strings.t('howto_step_bid'),
      strings.t('howto_step_discount'),
      strings.t('howto_step_sell'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('howto_title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...steps.map(
              (step) => Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.brightness_1, size: 10),
                    const SizedBox(width: Spacing.sm),
                    Expanded(child: Text(step)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(strings.t('howto_start_tour')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
