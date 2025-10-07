import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../widgets/glass_card.dart';

class SellBuyPage extends StatefulWidget {
  const SellBuyPage({super.key});

  @override
  State<SellBuyPage> createState() => _SellBuyPageState();
}

class _SellBuyPageState extends State<SellBuyPage> {
  late final ValueNotifier<bool> _isSellNotifier;
  final _sellTitleController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _sellDescController = TextEditingController();
  final _buyMinController = TextEditingController();
  final _buyMaxController = TextEditingController();
  late final ValueNotifier<String?> _imageNotifier;

  @override
  void initState() {
    super.initState();
    _isSellNotifier = ValueNotifier<bool>(true);
    _imageNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    _isSellNotifier.dispose();
    _sellTitleController.dispose();
    _sellPriceController.dispose();
    _sellDescController.dispose();
    _buyMinController.dispose();
    _buyMaxController.dispose();
    _imageNotifier.dispose();
    super.dispose();
  }

  void _mockPickImage(LanguageManager lang) {
    _imageNotifier.value = lang.t('image_selected');
  }

  void _submitForm(LanguageManager lang) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(lang.t('submit'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('sell_buy')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GlassCard(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isSellNotifier,
                builder: (context, isSell, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _isSellNotifier.value = true,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSell
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface.withOpacity(0.6),
                            foregroundColor: isSell
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          child: Text(lang.t('sell')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _isSellNotifier.value = false,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isSell
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface.withOpacity(0.6),
                            foregroundColor: !isSell
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          child: Text(lang.t('buy')),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isSellNotifier,
                builder: (context, isSell, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isSell
                        ? _SellForm(
                            titleController: _sellTitleController,
                            priceController: _sellPriceController,
                            descriptionController: _sellDescController,
                            imageNotifier: _imageNotifier,
                            onPickImage: () => _mockPickImage(lang),
                            onSubmit: () => _submitForm(lang),
                            lang: lang,
                          )
                        : _BuyForm(
                            minController: _buyMinController,
                            maxController: _buyMaxController,
                            onSubmit: () => _submitForm(lang),
                            lang: lang,
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellForm extends StatelessWidget {
  const _SellForm({
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.imageNotifier,
    required this.onPickImage,
    required this.onSubmit,
    required this.lang,
  });

  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final ValueListenable<String?> imageNotifier;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;
  final LanguageManager lang;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('sell_form'),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.t('sell_form_title'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: lang.t('sell_form_title')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: lang.t('sell_form_price')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(labelText: lang.t('sell_form_desc')),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onPickImage,
              icon: const Icon(Icons.image_rounded),
              label: Text(lang.t('pick_image')),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: imageNotifier,
              builder: (context, file, _) {
                if (file == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    file,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onSubmit,
                child: Text(lang.t('submit')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyForm extends StatelessWidget {
  const _BuyForm({
    required this.minController,
    required this.maxController,
    required this.onSubmit,
    required this.lang,
  });

  final TextEditingController minController;
  final TextEditingController maxController;
  final VoidCallback onSubmit;
  final LanguageManager lang;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('buy_form'),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.t('buy'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: minController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: lang.t('buy_form_min')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: lang.t('buy_form_max')),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onSubmit,
                child: Text(lang.t('submit')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
