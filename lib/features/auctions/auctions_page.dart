import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/strings.dart';
import '../../application/stores.dart';
import '../../core/design_tokens.dart';
import '../../core/result.dart';
import '../../domain/entities.dart';

class AuctionsPage extends StatefulWidget {
  const AuctionsPage({super.key});

  @override
  State<AuctionsPage> createState() => _AuctionsPageState();
}

class _AuctionsPageState extends State<AuctionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scope = AppScope.of(context);
      if (scope.catalogStore.value.products.isEmpty) {
        scope.fetchProducts.call();
      }
    });
  }

  Future<void> _placeBid(BuildContext context, Product product, Auction auction) async {
    final strings = AppStrings.of(context);
    final controller = TextEditingController(text: (auction.currentBid + auction.minIncrement).toStringAsFixed(2));
    final confirmed = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.t('label_bid_now')),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: strings.t('label_bid_now')),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.t('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null) {
                  Navigator.of(context).pop(value);
                }
              },
              child: Text(strings.t('label_bid_now')),
            )
          ],
        );
      },
    );
    if (confirmed != null) {
      final scope = AppScope.of(context);
      await scope.placeBid.call(product.id, confirmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = AppStrings.of(context);
    return ValueListenableBuilder<CatalogState>(
      valueListenable: scope.catalogStore,
      builder: (context, state, _) {
        final auctions = state.products.where((p) => p.isAuction).toList();
        if (auctions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            await scope.fetchProducts.call();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: auctions.length,
            itemBuilder: (context, index) {
              final product = auctions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: StreamBuilder<Result<Auction>>(
                    stream: scope.productRepository.watchAuction(product.id),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      if (data == null || data is Failure<Auction>) {
                        return Text(strings.t('error_title'));
                      }
                      final auction = data.data;
                      final remaining = auction.endsAt.difference(DateTime.now());
                      final minutes = remaining.inMinutes;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: Spacing.sm),
                          Text('${strings.t('label_bid_now')}: ${auction.currentBid.toStringAsFixed(2)}'),
                          const SizedBox(height: Spacing.sm),
                          Text('${strings.t('min_left')}: $minutes'),
                          const SizedBox(height: Spacing.md),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: ElevatedButton(
                              onPressed: () => _placeBid(context, product, auction),
                              child: Text(strings.t('label_bid_now')),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
