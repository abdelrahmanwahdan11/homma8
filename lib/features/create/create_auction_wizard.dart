import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Auction draft saved (mock publish soon)')),
      );
      AppStateScope.of(context).clearDraft('sp_draft_auction_v1');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: const Text('Images'),
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
                      .map((entry) => Chip(label: Text('Mock image ${entry.key + 1}')))
                      .toList(),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _addImage, child: const Text('Add placeholder image')),
                if (_images.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('At least one image required'),
                  ),
              ],
            ),
          ),
          Step(
            title: const Text('Details'),
            isActive: _currentStep >= 1,
            content: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: Validators.requireTitle,
                  onChanged: (_) => _persistDraft(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  onChanged: (_) => _persistDraft(),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Pricing'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                TextFormField(
                  controller: _startPriceController,
                  decoration: const InputDecoration(labelText: 'Start price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.requirePositive(double.tryParse(value ?? ''), label: 'Price'),
                  onChanged: (_) => _persistDraft(),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Publish'),
            isActive: _currentStep >= 3,
            content: Column(
              children: [
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (_) => _persistDraft(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  onChanged: (_) => _persistDraft(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: const Text('Publish mock')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
