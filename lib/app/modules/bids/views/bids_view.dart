import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/glass_card.dart';
import '../controllers/bids_controller.dart';

class BidsView extends GetView<BidsController> {
  const BidsView({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final content = Obx(
      () {
        final bids = controller.bids;
        if (bids.isEmpty) {
          return Center(child: Text('bids_empty'.tr));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bids.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final bid = bids[index];
            final item = controller.itemFor(bid.itemId);
            return GlassCard(
              child: ListTile(
                leading: const Icon(Icons.gavel_rounded),
                title: Text('${bid.amount.toStringAsFixed(0)} ${item?.currency ?? ''}'),
                subtitle: Text(item?.title ?? ''),
                trailing: Text(bid.status.tr),
              ),
            );
          },
        );
      },
    );
    if (embed) return content;
    return Scaffold(
      appBar: AppBar(title: Text('nav_bids'.tr)),
      body: content,
    );
  }
}
