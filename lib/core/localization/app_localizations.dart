import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations._(this.locale, this._localizedStrings);

  final Locale locale;
  final Map<String, String> _localizedStrings;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const localizationsDelegates = [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static Future<AppLocalizations> load(Locale locale) async {
    final resolvedLocale = supportedLocales.firstWhere(
      (supported) => supported.languageCode == locale.languageCode,
      orElse: () => supportedLocales.first,
    );
    final primary = await _loadAsset(resolvedLocale.languageCode);
    Map<String, String> translations = Map<String, String>.from(primary);

    if (resolvedLocale.languageCode != 'en') {
      final fallback = await _loadAsset('en');
      translations = {...fallback, ...translations};
    }

    return AppLocalizations._(resolvedLocale, translations);
  }

  static Future<Map<String, String>> _loadAsset(String languageCode) async {
    final raw = await rootBundle.loadString('lib/core/localization/$languageCode.arb');
    final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;
    final result = <String, String>{};
    for (final entry in data.entries) {
      if (!entry.key.startsWith('@')) {
        result[entry.key] = entry.value.toString();
      }
    }
    return result;
  }

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'AppLocalizations not found in context');
    return localizations!;
  }

  String get languageCode => locale.languageCode;

  bool get isRtl => ui.Bidi.isRtlLanguage(languageCode);

  String translate(String key) => _localizedStrings[key] ?? key;

  String operator [](String key) => translate(key);
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((it) => it.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
