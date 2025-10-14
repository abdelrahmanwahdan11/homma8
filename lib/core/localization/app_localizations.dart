import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart' as generated;
import 'package:flutter_localizations/flutter_localizations.dart';

export '../../l10n/app_localizations.dart';

typedef AppLocalizations = generated.AppLocalizations;

const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
