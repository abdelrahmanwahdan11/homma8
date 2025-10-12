class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
    caseSensitive: false,
  );

  static final RegExp _passwordLetter = RegExp(r'[A-Za-z]');
  static final RegExp _passwordNumber = RegExp(r'[0-9]');
  static final RegExp _phonePattern = RegExp(r'^\+?[0-9]{7,15}$');

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'required';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'invalid';
    }
    return null;
  }

  static String? password(String? value) {
    final input = value ?? '';
    if (input.isEmpty) {
      return 'required';
    }
    if (input.length < 8) {
      return 'min_length';
    }
    if (!_passwordLetter.hasMatch(input)) {
      return 'letter';
    }
    if (!_passwordNumber.hasMatch(input)) {
      return 'number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? other) {
    final result = password(value);
    if (result != null) {
      return result;
    }
    if (value != other) {
      return 'mismatch';
    }
    return null;
  }

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length < 2) {
      return 'min_length';
    }
    return null;
  }

  static String? phone(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return null;
    }
    if (!_phonePattern.hasMatch(input)) {
      return 'invalid';
    }
    return null;
  }

  static String? price(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'required';
    }
    final parsed = double.tryParse(input.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return 'invalid';
    }
    return null;
  }
}
