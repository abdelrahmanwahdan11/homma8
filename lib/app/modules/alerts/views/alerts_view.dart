import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/glass_card.dart';
import '../controllers/alerts_controller.dart';

class AlertsView extends GetView<AlertsController> {
  const AlertsView({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final list = Obx(
      () {
        final alerts = controller.alerts;
        if (alerts.isEmpty) {
          return Center(child: Text('alerts_empty'.tr));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final alert = alerts[index];
            return GlassCard(
              child: ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: Text(alert.title),
                subtitle: Text('${alert.location} • ${alert.category}'),
                trailing: Switch(value: alert.active, onChanged: (_) {}),
              ),
            );
          },
        );
      },
    );
    if (embed) return list;
    return Scaffold(
      appBar: AppBar(title: Text('nav_alerts'.tr)),
      body: list,
    );
  }
}
