import 'package:flutter/material.dart';

import '../../../app/strings.dart';
import '../../../core/design_tokens.dart';
import '../../../core/widgets/product_image_placeholder.dart';
import '../../../domain/entities.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.discountBadgeKey,
    this.bidButtonKey,
    super.key,
  });

  final Product product;
  final GlobalKey? discountBadgeKey;
  final GlobalKey? bidButtonKey;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);
    final price = product.isAuction ? product.currentPrice : product.currentPrice;
    return Card(
      elevation: Elevations.card,
      shape: RoundedRectangleBorder(borderRadius: Radii.large),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: ProductImagePlaceholder(
                  label:
                      product.images.isNotEmpty ? product.images.first : product.title,
                  borderRadius: Radii.large,
                  aspectRatio: 4 / 3,
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(product.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: Spacing.sm),
            Text('${price.toStringAsFixed(2)}'),
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.sm,
              children: [
                Chip(
                  label: Text(product.category),
                ),
                Chip(
                  label: Text(conditionLabel(product.condition, {
                    'new': strings.t('condition_new'),
                    'likeNew': strings.t('condition_likeNew'),
                    'good': strings.t('condition_good'),
                    'fair': strings.t('condition_fair'),
                  })),
                ),
                if (product.isAuction)
                  Chip(
                    avatar: const Icon(Icons.gavel, size: 18),
                    label: Text(strings.t('auction_label')),
                  )
                else
                  Chip(
                    key: discountBadgeKey,
                    avatar: const Icon(Icons.percent, size: 18),
                    label: Text('${strings.t('discount_label')}: ${product.discountPercent.toStringAsFixed(0)}%'),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                const Icon(Icons.visibility, size: 16),
                const SizedBox(width: Spacing.xs),
                Text('${product.watchers}'),
                const SizedBox(width: Spacing.md),
                const Icon(Icons.local_fire_department, size: 16),
                const SizedBox(width: Spacing.xs),
                Text('${product.demandCount}'),
                const Spacer(),
                if (product.isAuction)
                  ElevatedButton(
                    key: bidButtonKey,
                    onPressed: () {},
                    child: Text(strings.t('label_bid_now')),
                  )
                else
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(strings.t('label_request_discount')),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
