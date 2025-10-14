import 'package:flutter/material.dart';

import '../../core/utils/validators.dart';

typedef BidCallback = Future<void> Function(double amount);

class PlaceBidModal extends StatefulWidget {
  const PlaceBidModal({super.key, required this.onSubmit, required this.currentBid});

  final BidCallback onSubmit;
  final double currentBid;

  @override
  State<PlaceBidModal> createState() => _PlaceBidModalState();
}

class _PlaceBidModalState extends State<PlaceBidModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await widget.onSubmit(double.parse(_amountController.text));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current bid: ${widget.currentBid.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Your bid'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  final result = Validators.requirePositive(amount, label: 'Bid');
                  if (result != null) return result;
                  if (amount! <= widget.currentBid) {
                    return 'Bid must be higher than current bid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Submit bid'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
