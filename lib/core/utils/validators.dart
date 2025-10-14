class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');

  static String? requireEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? requirePassword(String? value, {int min = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password required';
    }
    if (value.length < min) {
      return 'Password must be at least $min characters';
    }
    return null;
  }

  static String? requireName(String? value, {int min = 2}) {
    if (value == null || value.trim().length < min) {
      return 'Name too short';
    }
    return null;
  }

  static String? confirmPassword(String? value, String other) {
    if (value != other) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? requireTitle(String? value, {int min = 3}) {
    if (value == null || value.trim().length < min) {
      return 'Title too short';
    }
    return null;
  }

  static String? requirePositive(num? value, {String label = 'Value'}) {
    if (value == null || value <= 0) {
      return '$label must be positive';
    }
    return null;
  }

  static String? requireImages(List<String> images) {
    if (images.isEmpty) {
      return 'Add at least one image';
    }
    return null;
  }
}
