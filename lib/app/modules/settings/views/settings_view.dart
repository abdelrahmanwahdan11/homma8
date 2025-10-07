import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final content = Obx(
      () => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('settings_theme'.tr, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text('theme_system'.tr)),
              ButtonSegment(value: ThemeMode.light, label: Text('theme_light'.tr)),
              ButtonSegment(value: ThemeMode.dark, label: Text('theme_dark'.tr)),
            ],
            selected: {controller.themeMode},
            onSelectionChanged: (value) => controller.updateTheme(value.first),
          ),
          const SizedBox(height: 24),
          Text('settings_locale'.tr, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SegmentedButton<Locale>(
            segments: [
              ButtonSegment(value: const Locale('en'), label: Text('locale_en'.tr)),
              ButtonSegment(value: const Locale('ar'), label: Text('locale_ar'.tr)),
            ],
            selected: {controller.locale},
            onSelectionChanged: (value) => controller.updateLocale(value.first),
          ),
          const SizedBox(height: 24),
          Text('settings_distance_unit'.tr,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'km', label: Text('distance_km'.tr)),
              ButtonSegment(value: 'mi', label: Text('distance_mi'.tr)),
            ],
            selected: {controller.distanceUnit},
            onSelectionChanged: (value) => controller.updateDistanceUnit(value.first),
          ),
          const SizedBox(height: 24),
          Text('settings_currency'.tr, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'AED', label: const Text('AED')),
              ButtonSegment(value: 'USD', label: const Text('USD')),
              ButtonSegment(value: 'EUR', label: const Text('EUR')),
            ],
            selected: {controller.currency},
            onSelectionChanged: (value) => controller.updateCurrency(value.first),
          ),
          const SizedBox(height: 24),
          ExpansionTile(
            title: Text('settings_features'.tr),
            children: [
              for (final entry in controller.featureToggles.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key)))
                SwitchListTile(
                  title: Text(entry.key.tr),
                  value: entry.value,
                  onChanged: (enabled) => controller.toggleFeature(entry.key, enabled),
                ),
            ],
          ),
        ],
      ),
    );
    if (embed) return content;
    return Scaffold(
      appBar: AppBar(title: Text('nav_settings'.tr)),
      body: content,
    );
  }
}
