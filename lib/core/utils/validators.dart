import '../localization/app_localizations.dart';

class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');

  static String? requireEmail(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return l10n?.errorEmailRequired ?? 'Email required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return l10n?.errorEmailInvalid ?? 'Enter a valid email';
    }
    return null;
  }

  static String? requirePassword(String? value, {int min = 6, AppLocalizations? l10n}) {
    if (value == null || value.isEmpty) {
      return l10n?.errorPasswordRequired ?? 'Password required';
    }
    if (value.length < min) {
      return l10n?.errorPasswordMin(min: min) ?? 'Password must be at least $min characters';
    }
    return null;
  }

  static String? requireName(String? value, {int min = 2, AppLocalizations? l10n}) {
    if (value == null || value.trim().length < min) {
      return l10n?.errorNameShort ?? 'Name too short';
    }
    return null;
  }

  static String? confirmPassword(String? value, String other, {AppLocalizations? l10n}) {
    if (value != other) {
      return l10n?.errorPasswordsMismatch ?? 'Passwords do not match';
    }
    return null;
  }

  static String? requireTitle(String? value, {int min = 3, AppLocalizations? l10n}) {
    if (value == null || value.trim().length < min) {
      return l10n?.errorTitleShort ?? 'Title too short';
    }
    return null;
  }

  static String? requirePositive(num? value, {String label = 'Value', AppLocalizations? l10n}) {
    if (value == null || value <= 0) {
      return l10n?.errorValueMustBePositive(label: label) ?? '$label must be positive';
    }
    return null;
  }

  static String? requireImages(List<String> images, {AppLocalizations? l10n}) {
    if (images.isEmpty) {
      return l10n?.errorAddImage ?? 'Add at least one image';
    }
    return null;
  }
}
