import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/glass_card.dart';
import '../controllers/sell_buy_controller.dart';

class SellBuyView extends GetView<SellBuyController> {
  const SellBuyView({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final content = DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: 'sell_tab_sell'.tr),
              Tab(text: 'sell_tab_want'.tr),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _SellForm(controller: controller),
                _WantForm(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
    if (embed) return content;
    return Scaffold(
      appBar: AppBar(title: Text('nav_sell_buy'.tr)),
      body: content,
    );
  }
}

class _SellForm extends StatelessWidget {
  const _SellForm({required this.controller});

  final SellBuyController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        child: Form(
          key: controller.sellFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.sellTitle,
                decoration: InputDecoration(labelText: 'label_name'.tr),
                validator: (value) => value == null || value.isEmpty ? 'validation_required'.tr : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.sellLocation,
                decoration: InputDecoration(labelText: 'label_location'.tr),
                validator: (value) => value == null || value.isEmpty ? 'validation_required'.tr : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.sellStartPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'label_start_price'.tr),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.sellBuyNowPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'label_buy_now_price'.tr),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: controller.submitSell,
                child: Text('sell_tab_sell'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WantForm extends StatelessWidget {
  const _WantForm({required this.controller});

  final SellBuyController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        child: Form(
          key: controller.wantFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.wantTitle,
                decoration: InputDecoration(labelText: 'label_name'.tr),
                validator: (value) => value == null || value.isEmpty ? 'validation_required'.tr : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.wantMinPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'label_min_price'.tr),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.wantMaxPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'label_max_price'.tr),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.wantLocation,
                decoration: InputDecoration(labelText: 'label_location'.tr),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: controller.submitWant,
                child: Text('sell_tab_want'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
