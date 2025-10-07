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
