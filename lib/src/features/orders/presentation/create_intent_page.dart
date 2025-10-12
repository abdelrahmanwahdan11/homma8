import 'package:flutter/material.dart';

import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../models/models.dart';

class CreateIntentPage extends StatefulWidget {
  const CreateIntentPage({super.key});

  @override
  State<CreateIntentPage> createState() => _CreateIntentPageState();
}

class _CreateIntentPageState extends State<CreateIntentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  String _condition = 'any';

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createIntent)),
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
                controller: _categoryController,
                decoration: InputDecoration(labelText: l10n.category),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.price),
                validator: Validators.price,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _condition,
                items: const [
                  DropdownMenuItem(value: 'any', child: Text('Any')),
                  DropdownMenuItem(value: 'new', child: Text('New')),
                  DropdownMenuItem(value: 'used', child: Text('Used')),
                ],
                onChanged: (value) => setState(() => _condition = value ?? 'any'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
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
    final intent = BuyIntent(
      id: 'intent_${state.intents.length + 1}',
      buyerId: state.user.id,
      title: _titleController.text.trim(),
      category: _categoryController.text.trim(),
      maxPrice: double.parse(_priceController.text.trim()),
      condition: _condition,
      notes: _notesController.text.trim(),
      status: 'active',
      createdAt: now,
    );
    state.addIntent(intent);
    Navigator.pop(context);
  }
}
