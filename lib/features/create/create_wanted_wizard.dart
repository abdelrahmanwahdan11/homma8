import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/utils/validators.dart';

class CreateWantedWizard extends StatefulWidget {
  const CreateWantedWizard({super.key});

  @override
  State<CreateWantedWizard> createState() => _CreateWantedWizardState();
}

class _CreateWantedWizardState extends State<CreateWantedWizard> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final _titleController = TextEditingController();
  final _specsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();

  bool _loadedDraft = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedDraft) return;
    final draft = AppStateScope.of(context).readDraft('sp_draft_wanted_v1');
    _titleController.text = draft['title']?.toString() ?? '';
    _specsController.text = draft['specs']?.toString() ?? '';
    _budgetController.text = draft['budget']?.toString() ?? '';
    _categoryController.text = draft['category']?.toString() ?? '';
    _locationController.text = draft['location']?.toString() ?? '';
    _loadedDraft = true;
  }

  void _persistDraft() {
    AppStateScope.of(context).saveDraft('sp_draft_wanted_v1', {
      'title': _titleController.text,
      'specs': _specsController.text,
      'budget': _budgetController.text,
      'category': _categoryController.text,
      'location': _locationController.text,
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wanted draft saved (mock publish soon)')),
      );
      AppStateScope.of(context).clearDraft('sp_draft_wanted_v1');
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
            title: const Text('Specs'),
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
                  controller: _specsController,
                  decoration: const InputDecoration(labelText: 'Specs'),
                  maxLines: 3,
                  onChanged: (_) => _persistDraft(),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Budget'),
            content: TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(labelText: 'Max price'),
              keyboardType: TextInputType.number,
              validator: (value) => Validators.requirePositive(double.tryParse(value ?? ''), label: 'Max price'),
              onChanged: (_) => _persistDraft(),
            ),
          ),
          Step(
            title: const Text('Category'),
            content: TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
              onChanged: (_) => _persistDraft(),
            ),
          ),
          Step(
            title: const Text('Publish'),
            content: Column(
              children: [
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
