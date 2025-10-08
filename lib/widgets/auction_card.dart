import 'package:flutter/material.dart';

import '../core/localization/language_manager.dart';
import '../core/theme/theme_manager.dart';
import '../models/auction_item.dart';
import 'animated_price.dart';
import 'glass_card.dart';
import 'primary_button.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({
    required this.item,
    required this.onTap,
    required this.onBid,
    required this.lang,
    required this.onToggleFavorite,
    required this.currencySymbol,
    super.key,
  });

  final AuctionItem item;
  final VoidCallback onTap;
  final VoidCallback onBid;
  final VoidCallback onToggleFavorite;
  final LanguageManager lang;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradients = Theme.of(context).extension<AppGradients>();
    return Hero(
      tag: item.id,
      child: GlassCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: '${item.id}_icon',
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      gradient: gradients?.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(item.icon, size: 28, color: Colors.white),
                  ),
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
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          key: ValueKey<bool>(isFavorite),
                          color: isFavorite
                              ? colorScheme.primary
                              : colorScheme.onSurface.withOpacity(0.45),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
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
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            const Spacer(),
            AnimatedPrice(
              priceNotifier: item.priceNotifier,
              currency: currencySymbol,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: lang.t('place_bid'),
                icon: Icons.gavel_rounded,
                onPressed: onBid,
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
