import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/settings_service.dart';

class SettingsController extends GetxController {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  ThemeMode get themeMode => _settingsService.themeMode.value;
  Locale get locale => _settingsService.locale.value;

  void updateTheme(ThemeMode mode) => _settingsService.updateTheme(mode);
  void updateLocale(Locale locale) {
    _settingsService.updateLocale(locale);
    Get.updateLocale(locale);
  }
}
