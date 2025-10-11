import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/strings.dart';
import '../../application/engines/suggestion_engine.dart';
import '../../core/design_tokens.dart';
import '../../domain/entities.dart';

enum SellTab { sell, wanted }

class SellPage extends StatefulWidget {
  const SellPage({required this.initialTab, this.tabKey, super.key});

  final SellTab initialTab;
  final Key? tabKey;

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: widget.initialTab.index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Column(
      key: widget.tabKey,
      children: [
        TabBar(
          controller: _controller,
          tabs: [
            Tab(text: strings.t('sell_title')),
            Tab(text: strings.t('wanted_title')),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: const [
              _SellForm(),
              _WantedForm(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SellForm extends StatefulWidget {
  const _SellForm();

  @override
  State<_SellForm> createState() => _SellFormState();
}

class _SellFormState extends State<_SellForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  Condition _condition = Condition.newCondition;
  Suggestion? _suggestion;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _computeSuggestion() {
    final scope = AppScope.of(context);
    final strings = AppStrings.of(context);
    final price = double.tryParse(_priceController.text) ?? 0;
    _suggestion = scope.suggestionEngine.suggest(
      condition: _condition,
      category: _categoryController.text,
      basePrice: price,
      recentDemand: scope.catalogStore.value.products
          .where((p) => p.category == _categoryController.text)
          .length,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${strings.t('form_recommendation')}: ${_suggestion!.mode}')),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final scope = AppScope.of(context);
    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: '',
      images: [_titleController.text],
      category: _categoryController.text,
      condition: _condition,
      isAuction: _suggestion?.mode == 'auction',
      basePrice: double.tryParse(_priceController.text) ?? 0,
      currentPrice: double.tryParse(_priceController.text) ?? 0,
      discountPercent: 0,
      demandCount: 0,
      watchers: 0,
      sellerId: scope.userStore.value.userId,
      createdAt: DateTime.now(),
      status: ProductStatus.draft,
    );
    await scope.createSellListing.call(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).t('btn_post_to_sell'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: strings.t('form_title')),
              validator: (value) => value == null || value.isEmpty ? strings.t('invalid_form') : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: strings.t('form_category')),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: strings.t('form_base_price')),
            ),
            const SizedBox(height: Spacing.md),
            DropdownButtonFormField<Condition>(
              value: _condition,
              onChanged: (value) => setState(() => _condition = value ?? Condition.newCondition),
              items: Condition.values
                  .map(
                    (condition) => DropdownMenuItem(
                      value: condition,
                      child: Text(conditionLabel(condition, {
                        'new': strings.t('condition_new'),
                        'likeNew': strings.t('condition_likeNew'),
                        'good': strings.t('condition_good'),
                        'fair': strings.t('condition_fair'),
                      })),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _computeSuggestion,
                  child: Text(strings.t('form_recommendation')),
                ),
                const SizedBox(width: Spacing.md),
                if (_suggestion != null)
                  Chip(
                    label: Text('${_suggestion!.mode} - ${_suggestion!.recommendedPrice.toStringAsFixed(2)}'),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(strings.t('btn_post_to_sell')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WantedForm extends StatefulWidget {
  const _WantedForm();

  @override
  State<_WantedForm> createState() => _WantedFormState();
}

class _WantedFormState extends State<_WantedForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final scope = AppScope.of(context);
    final item = WantedItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      category: _categoryController.text,
      targetPrice: double.tryParse(_priceController.text) ?? 0,
      notes: _notesController.text,
    );
    await scope.createWantedItem.call(item);
    scope.registerPriceAlert.call(
      PriceAlert(
        wantedId: item.id,
        productId: 'p1',
        matchedAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).t('btn_post_wanted'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: strings.t('form_title')),
              validator: (value) => value == null || value.isEmpty ? strings.t('invalid_form') : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: strings.t('form_category')),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: strings.t('label_target_price')),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: strings.t('form_notes')),
              maxLines: 3,
            ),
            const SizedBox(height: Spacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(strings.t('btn_post_wanted')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
