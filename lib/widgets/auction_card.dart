import 'package:flutter/material.dart';

import '../core/localization/language_manager.dart';
import '../models/auction_item.dart';
import 'animated_price.dart';
import 'glass_card.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({
    required this.item,
    required this.onTap,
    required this.onBid,
    required this.lang,
    required this.onToggleFavorite,
    super.key,
  });

  final AuctionItem item;
  final VoidCallback onTap;
  final VoidCallback onBid;
  final VoidCallback onToggleFavorite;
  final LanguageManager lang;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = lang.locale.languageCode == 'ar' ? 'د.إ ' : 'USD ';
    return Hero(
      tag: item.id,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.icon, size: 28, color: colorScheme.primary),
                ),
                const Spacer(),
                ValueListenableBuilder<bool>(
                  valueListenable: item.favoriteNotifier,
                  builder: (context, isFavorite, _) {
                    return IconButton(
                      onPressed: onToggleFavorite,
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) => ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey<bool>(isFavorite),
                          color:
                              isFavorite ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              item.subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            const Spacer(),
            AnimatedPrice(priceNotifier: item.priceNotifier, currency: currency),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBid,
                child: Text(lang.t('place_bid')),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onTap,
                child: Text(lang.t('view_details')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
