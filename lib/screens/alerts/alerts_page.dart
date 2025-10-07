import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../models/price_alert.dart';
import '../../widgets/glass_card.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final _titleController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final ValueNotifier<List<PriceAlert>> _alertsNotifier =
      ValueNotifier<List<PriceAlert>>(<PriceAlert>[]);

  void _addAlert(LanguageManager lang) {
    final title = _titleController.text.trim();
    final minText = _minController.text.trim();
    final maxText = _maxController.text.trim();
    final min = double.tryParse(minText);
    final max = double.tryParse(maxText);
    if (title.isEmpty || min == null || max == null || min < 0 || max < min) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t('invalid_alert'))),
      );
      return;
    }
    final alert = PriceAlert(title: title, minPrice: min, maxPrice: max);
    final alerts = List<PriceAlert>.from(_alertsNotifier.value)..add(alert);
    _alertsNotifier.value = alerts;
    _titleController.clear();
    _minController.clear();
    _maxController.clear();
  }

  @override
  void dispose() {
    for (final alert in _alertsNotifier.value) {
      alert.dispose();
    }
    _alertsNotifier.dispose();
    _titleController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('alerts')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('add_alert'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: lang.t('alert_title')),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: lang.t('min_price')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: lang.t('max_price')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => _addAlert(lang),
                      child: Text(lang.t('create')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<List<PriceAlert>>(
              valueListenable: _alertsNotifier,
              builder: (context, alerts, _) {
                if (alerts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      lang.t('alerts_empty'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  );
                }
                final currency = lang.locale.languageCode == 'ar' ? 'د.إ' : 'USD';
                return Column(
                  children: alerts.map((alert) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alert.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\${currency} ${alert.minPrice.toStringAsFixed(0)} - \${currency} ${alert.maxPrice.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: alert.activeNotifier,
                              builder: (context, active, _) {
                                return Switch(
                                  value: active,
                                  onChanged: (_) => alert.toggle(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
