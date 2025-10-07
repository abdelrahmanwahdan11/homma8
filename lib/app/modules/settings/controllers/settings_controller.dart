import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/settings_service.dart';

class SettingsController extends GetxController {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  ThemeMode get themeMode => _settingsService.themeMode.value;
  Locale get locale => _settingsService.locale.value;
  String get distanceUnit => _settingsService.distanceUnit.value;
  String get currency => _settingsService.currency.value;
  RxMap<String, bool> get featureToggles => _settingsService.featureToggles;

  void updateTheme(ThemeMode mode) => _settingsService.updateTheme(mode);
  void updateLocale(Locale locale) {
    _settingsService.updateLocale(locale);
    Get.updateLocale(locale);
  }

  void updateDistanceUnit(String unit) => _settingsService.updateDistanceUnit(unit);

  void updateCurrency(String value) => _settingsService.updateCurrency(value);

  void toggleFeature(String key, bool enabled) => _settingsService.toggleFeature(key, enabled);
}
