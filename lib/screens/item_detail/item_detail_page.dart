import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../models/auction_item.dart';
import '../../widgets/animated_price.dart';
import '../../widgets/countdown_timer.dart';
import '../../widgets/glass_card.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({required this.item, super.key});

  final AuctionItem item;

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final currency = lang.locale.languageCode == 'ar' ? 'د.إ ' : 'USD ';
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: item.id,
              child: GlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Icon(
                        item.icon,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedPrice(priceNotifier: item.priceNotifier, currency: currency),
                    const SizedBox(height: 12),
                    Text(
                      lang.t('time_left'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    CountdownTimer(endTime: item.endTime),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('description'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                item.placeBid(100);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lang.t('bid_success'))),
                );
              },
              icon: const Icon(Icons.local_fire_department_rounded),
              label: Text(lang.t('bid_now')),
            ),
          ],
        ),
      ),
    );
  }
}
