import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../core/theme/theme_manager.dart';
import '../../models/price_alert.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/primary_button.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final _titleController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final ValueNotifier<String?> _errorNotifier = ValueNotifier<String?>(null);

  void _addAlert(LanguageManager lang, _AppStateScope state) {
    final title = _titleController.text.trim();
    final minText = _minController.text.trim();
    final maxText = _maxController.text.trim();
    const pattern = r'^[0-9]+(\.[0-9]{1,2})?$';
    final numberRegExp = RegExp(pattern);
    if (title.isEmpty ||
        !numberRegExp.hasMatch(minText) ||
        !numberRegExp.hasMatch(maxText)) {
      _errorNotifier.value = lang.t('invalid_alert');
      return;
    }
    final min = double.tryParse(minText) ?? 0;
    final max = double.tryParse(maxText) ?? 0;
    if (min <= 0 || max <= 0 || min >= max) {
      _errorNotifier.value = lang.t('invalid_alert');
      return;
    }
    _errorNotifier.value = null;
    final alert = PriceAlert(title: title, minPrice: min, maxPrice: max);
    state.addAlert(alert);
    _titleController.clear();
    _minController.clear();
    _maxController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _errorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final state = AppState.of(context);
    final gradients = Theme.of(context).extension<AppGradients>();
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(lang.t('alerts')),
          flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: gradients?.primary),
          ),
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
                    const SizedBox(height: 12),
                    ValueListenableBuilder<String?>(
                      valueListenable: _errorNotifier,
                      builder: (context, error, _) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: error == null
                              ? const SizedBox(height: 20)
                              : Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    error,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.redAccent),
                                  ),
                                ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PrimaryButton(
                        label: lang.t('create'),
                        icon: Icons.add_alert_rounded,
                        onPressed: () => _addAlert(lang, state),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<List<PriceAlert>>(
                valueListenable: state.alertsNotifier,
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
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                    );
                  }
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
                                    ValueListenableBuilder<String>(
                                      valueListenable: state.currencyNotifier,
                                      builder: (context, symbol, _) {
                                        return Text(
                                          '$symbol ${alert.minPrice.toStringAsFixed(0)} - $symbol ${alert.maxPrice.toStringAsFixed(0)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.6),
                                              ),
                                        );
                                      },
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
      ),
    );
  }
}
