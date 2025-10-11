import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/app_scope.dart';
import '../../models/listing.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final app = AppScope.of(context);
    final listings = app.listings;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          title: Text(l10n.browse),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              tooltip: l10n.search_hint,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilterChip(
                  label: Text(l10n.ending_soon),
                  selected: true,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: Text(l10n.most_viewed),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: Text(l10n.recommended_for_you),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverList.builder(
            itemBuilder: (context, index) {
              final listing = listings[index % listings.length];
              return _AuctionCard(listing: listing);
            },
            itemCount: listings.length,
          ),
        ),
      ],
    );
  }
}

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final timeLeft = app.timeLeft(listing);
    final watched = app.isWatched(listing.id);
    final localizations = MaterialLocalizations.of(context);
    final color = timeLeft.inMinutes <= 1
        ? Colors.red.withOpacity(0.12)
        : timeLeft.inMinutes <= 10
            ? Colors.orange.withOpacity(0.12)
            : Colors.green.withOpacity(0.12);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/auction', arguments: listing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                listing.images.first,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  final progress = loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null;
                  return Center(
                    child: CircularProgressIndicator(value: progress),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          listing.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => app.toggleWatch(listing.id),
                        icon: Icon(watched ? Icons.star : Icons.star_border),
                        tooltip: watched ? 'إزالة من المتابعة' : 'متابعة',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(localizations.formatDecimal(listing.currentPrice)),
                      Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          '${timeLeft.inMinutes}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _openBidSheet(context, listing),
                          child: Text(AppLocalizations.of(context)!.bid_now),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('معلومات إرشادية (محاكاة)')),
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.ai_insights),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBidSheet(BuildContext context, Listing listing) {
    final TextEditingController controller = TextEditingController(
      text: (listing.currentPrice + listing.minIncrement).toStringAsFixed(0),
    );
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final app = AppScope.of(sheetContext);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('السعر الحالي: ${listing.currentPrice}'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'عرضك'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final value = double.tryParse(controller.text);
                  if (value == null) {
                    Navigator.pop(sheetContext);
                    return;
                  }
                  app.placeBid(listingId: listing.id, amount: value);
                  Navigator.pop(sheetContext);
                },
                child: const Text('تأكيد'),
              ),
            ],
          ),
        );
      },
    );
  }
}
