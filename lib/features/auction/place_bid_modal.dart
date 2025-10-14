import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
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
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.currentBidValue(
                  amount: l10n.usdAmount(amount: widget.currentBid.toStringAsFixed(0)),
                ),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: l10n.yourBid),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  final result = Validators.requirePositive(amount, label: l10n.yourBid, l10n: l10n);
                  if (result != null) return result;
                  if (amount! <= widget.currentBid) {
                    return l10n.bidMustExceedCurrent;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(l10n.submitBid),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
