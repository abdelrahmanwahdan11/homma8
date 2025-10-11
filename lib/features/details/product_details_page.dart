import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/strings.dart';
import '../../core/design_tokens.dart';
import '../../core/widgets/product_image_placeholder.dart';
import '../../domain/entities.dart';

class ProductDetailsArgs {
  ProductDetailsArgs({required this.product});

  final Product product;
}

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({required this.args, super.key});

  final ProductDetailsArgs args;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final product = args.product;
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: PageView(
              children: (product.images.isEmpty ? [product.title] : product.images)
                  .map(
                    (image) => Hero(
                      tag: 'product-${product.id}',
                      child: ProductImagePlaceholder(
                        label: image,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: Spacing.sm),
                  Text(product.description),
                  const SizedBox(height: Spacing.md),
                  Row(
                    children: [
                      Chip(label: Text(product.category)),
                      const SizedBox(width: Spacing.sm),
                      Chip(label: Text('${strings.t('discount_label')}: ${product.discountPercent.toStringAsFixed(0)}%')),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  Text('Watchers: ${product.watchers}'),
                  Text('Demand: ${product.demandCount}'),
                  const SizedBox(height: Spacing.md),
                  if (product.isAuction)
                    Text('${strings.t('label_bid_now')}: ${product.currentPrice.toStringAsFixed(2)}')
                  else
                    Text('${strings.t('discount_label')}: ${product.discountPercent.toStringAsFixed(0)}%'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: ElevatedButton(
            onPressed: () {
              final scope = AppScope.of(context);
              if (product.isAuction) {
                scope.placeBid.call(product.id, product.currentPrice + 5);
              } else {
                scope.swipeRight.call(product);
              }
            },
            child: Text(product.isAuction ? strings.t('label_bid_now') : strings.t('label_watch')),
          ),
        ),
      ),
    );
  }
}
