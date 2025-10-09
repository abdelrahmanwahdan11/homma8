import 'package:flutter/material.dart';

import '../core/localization/language_manager.dart';
import 'glass_container.dart';

class BidModule extends StatefulWidget {
  const BidModule({
    required this.currentBid,
    required this.onSubmit,
    super.key,
  });

  final double currentBid;
  final ValueChanged<double> onSubmit;

  @override
  State<BidModule> createState() => _BidModuleState();
}

class _BidModuleState extends State<BidModule> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: (widget.currentBid + 10).toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.t('place_bid'),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: lang.t('bid_now'),
              ),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= widget.currentBid) {
                  return lang.t('bid_too_low');
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final value = double.parse(_controller.text);
                        widget.onSubmit(value);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(lang.t('bid_success'))),
                        );
                      }
                    },
                    child: Text(lang.t('confirm')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(lang.t('cancel')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
