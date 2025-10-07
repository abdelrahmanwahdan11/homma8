class FormValidators {
  static final _emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  static final _passwordRegExp =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
  static final _phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'validation_required';
    if (!_emailRegExp.hasMatch(value)) return 'validation_email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'validation_required';
    if (!_passwordRegExp.hasMatch(value)) return 'validation_password';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'validation_required';
    if (!_phoneRegExp.hasMatch(value)) return 'validation_phone';
    return null;
  }

  static String? priceRange(double min, double max) {
    if (min < 0 || max < min) return 'validation_price_range';
    return null;
  }
}
