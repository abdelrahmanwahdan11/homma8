import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/validators.dart';

class CreateAuctionWizard extends StatefulWidget {
  const CreateAuctionWizard({super.key});

  @override
  State<CreateAuctionWizard> createState() => _CreateAuctionWizardState();
}

class _CreateAuctionWizardState extends State<CreateAuctionWizard> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _startPriceController = TextEditingController();
  final _locationController = TextEditingController();
  final List<String> _images = <String>[];
  String _nextImageSeed() => 'mock_image_${DateTime.now().microsecondsSinceEpoch}_${_images.length}';

  bool _loadedDraft = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedDraft) return;
    final draft = AppStateScope.of(context).readDraft('sp_draft_auction_v1');
    _titleController.text = draft['title']?.toString() ?? '';
    _descController.text = draft['desc']?.toString() ?? '';
    _categoryController.text = draft['category']?.toString() ?? '';
    _startPriceController.text = draft['price']?.toString() ?? '';
    _locationController.text = draft['location']?.toString() ?? '';
    final imgs = draft['images'];
    if (imgs is List) {
      _images.addAll(imgs.cast<String>());
    }
    _loadedDraft = true;
  }

  void _persistDraft() {
    AppStateScope.of(context).saveDraft('sp_draft_auction_v1', {
      'title': _titleController.text,
      'desc': _descController.text,
      'category': _categoryController.text,
      'price': _startPriceController.text,
      'location': _locationController.text,
      'images': _images,
    });
  }

  void _addImage() {
    setState(() {
      _images.add(_nextImageSeed());
    });
    _persistDraft();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.auctionDraftSavedMock)),
      );
      AppStateScope.of(context).clearDraft('sp_draft_auction_v1');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            _submit();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: Text(l10n.images),
            isActive: _currentStep >= 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _images
                      .asMap()
                      .entries
                      .map((entry) => Chip(label: Text(l10n.mockImageLabel(index: entry.key + 1))))
                      .toList(),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _addImage, child: Text(l10n.addPlaceholderImage)),
                if (_images.isEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8),
                    child: Text(l10n.atLeastOneImageRequired),
                  ),
              ],
            ),
          ),
          Step(
            title: Text(l10n.details),
            isActive: _currentStep >= 1,
            content: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: l10n.title),
                  validator: (value) => Validators.requireTitle(value, l10n: l10n),
                  onChanged: (_) => _persistDraft(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: l10n.description),
                  maxLines: 4,
                  onChanged: (_) => _persistDraft(),
                ),
              ],
            ),
          ),
          Step(
            title: Text(l10n.pricing),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                TextFormField(
                  controller: _startPriceController,
                  decoration: InputDecoration(labelText: l10n.startPrice),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      Validators.requirePositive(double.tryParse(value ?? ''), label: l10n.price, l10n: l10n),
                  onChanged: (_) => _persistDraft(),
                ),
              ],
            ),
          ),
          Step(
            title: Text(l10n.publish),
            isActive: _currentStep >= 3,
            content: Column(
              children: [
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: l10n.category),
                  onChanged: (_) => _persistDraft(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: l10n.location),
                  onChanged: (_) => _persistDraft(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: Text(l10n.publishMock)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
