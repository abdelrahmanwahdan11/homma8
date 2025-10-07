import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/widgets/glass_card.dart';
import '../controllers/item_detail_controller.dart';

class ItemDetailView extends GetView<ItemDetailController> {
  const ItemDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('item_ai_summary'.tr),
      ),
      body: Obx(() {
        final item = controller.item.value;
        if (item == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final isLarge = constraints.maxWidth >= 900;
            final hero = Hero(
              tag: 'item-${item.id}',
              child: CachedNetworkImage(
                imageUrl: item.images.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.memory(kTransparentImage, fit: BoxFit.cover),
              ),
            );
            final detail = _DetailContent(controller: controller);
            if (isLarge) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: hero),
                  Expanded(child: detail),
                ],
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(item.title),
                    background: hero,
                  ),
                ),
                SliverToBoxAdapter(child: detail),
              ],
            );
          },
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: controller.placeBid,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            ),
            child: Text('action_bid'.tr),
          ),
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.controller});

  final ItemDetailController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = controller.item.value!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(item.location, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.currency} ${item.currentBid.toStringAsFixed(0)}',
                    style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text('label_end_time'.trParams({'time': DateFormat.yMMMd().add_jm().format(item.endAt.toLocal())})),
                const SizedBox(height: 12),
                Text('item_ai_summary'.tr),
                const SizedBox(height: 8),
                Text(item.aiSummary),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('item_specs'.tr, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final entry in item.specs.entries)
                GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: theme.textTheme.labelLarge),
                      Text(entry.value, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('item_bid_history'.tr, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Obx(
            () => Column(
              children: [
                for (final bid in controller.bids)
                  ListTile(
                    leading: const Icon(Icons.gavel_rounded),
                    title: Text('${bid.amount.toStringAsFixed(0)} ${item.currency}'),
                    subtitle: Text(bid.time.toLocal().toString()),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('bid_amount_label'.tr, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: controller.bidController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '${item.currency} ${(item.currentBid * 1.05).toStringAsFixed(0)}',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final percent in [0.05, 0.1, 0.15])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: () => controller.addStep(percent),
                    child: Text('bid_step_plus'.trParams({
                      'percent': (percent * 100).toStringAsFixed(0),
                    })),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('safety_tips_title'.tr, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text('• Meet in safe public places.\n• Inspect items before paying.\n• Use secure payment methods.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
