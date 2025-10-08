import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../core/theme/theme_manager.dart';
import '../../models/auction_item.dart';
import '../../models/bid.dart';
import '../../widgets/animated_price.dart';
import '../../widgets/countdown_timer.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_background.dart';

class BidsPage extends StatelessWidget {
  const BidsPage({required this.items, super.key});

  final List<AuctionItem> items;

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final state = AppState.of(context);
    final gradients = Theme.of(context).extension<AppGradients>();
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(lang.t('bids')),
          flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: gradients?.primary),
          ),
        ),
        body: ValueListenableBuilder<List<Bid>>(
          valueListenable: state.bidsNotifier,
          builder: (context, bids, _) {
            if (bids.isEmpty) {
              return Center(
                child: Text(
                  lang.t('no_bids'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
              );
            }
            return ValueListenableBuilder<String>(
              valueListenable: state.currencyNotifier,
              builder: (context, symbol, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: bids.length,
                  itemBuilder: (context, index) {
                    final bid = bids[index];
                    final item = bid.item;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    gradient: gradients?.surface,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(item.icon,
                                      size: 24,
                                      color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            AnimatedPrice(
                              priceNotifier: item.priceNotifier,
                              currency: '$symbol ',
                            ),
                            const SizedBox(height: 12),
                            Text(
                              lang.t('countdown'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                            ),
                            const SizedBox(height: 6),
                            CountdownTimer(endTime: item.endTime),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
