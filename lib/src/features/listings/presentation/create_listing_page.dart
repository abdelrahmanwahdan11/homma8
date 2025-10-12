import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../models/models.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController(text: 'https://picsum.photos/seed/new/800/600');
  final _locationController = TextEditingController();
  Duration _duration = const Duration(days: 7);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createListing)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.title),
                validator: (value) => value != null && value.length >= 3 ? null : l10n.invalid,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: l10n.description),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: l10n.category),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.startPrice),
                validator: Validators.price,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: l10n.location),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Duration: ${_duration.inDays} days'),
                trailing: const Icon(Icons.timer),
                onTap: () async {
                  final duration = await showModalBottomSheet<Duration>(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final days in [3, 7, 14, 30])
                              ListTile(
                                title: Text('$days days'),
                                onTap: () => Navigator.pop(context, Duration(days: days)),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                  if (duration != null) {
                    setState(() => _duration = duration);
                  }
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submit(context);
                  }
                },
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    final state = AppScope.of(context);
    final now = DateTime.now();
    final id = 'item_${state.items.length + 1}';
    final item = Item(
      id: id,
      title: _titleController.text.trim(),
      subtitle: _titleController.text.trim(),
      image: _imageController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      condition: 'new',
      locationText: _locationController.text.trim(),
      basePrice: double.parse(_priceController.text.trim()),
      endAt: now.add(_duration),
      tags: <String>[_categoryController.text.trim(), 'new'],
      createdAt: now,
    );
    final listing = SellListing(
      id: 'listing_${state.listings.length + 1}',
      itemId: item.id,
      sellerId: state.user.id,
      askPrice: item.basePrice,
      status: 'active',
      createdAt: now,
      endAt: now.add(_duration),
      currentBid: item.basePrice,
      bidCount: 0,
    );
    state.addListing(item: item, listing: listing);
    AppRouterDelegate.of(context).go('/swipe');
  }
}
