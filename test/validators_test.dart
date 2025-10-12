import 'package:flutter_test/flutter_test.dart';

import 'package:bentobid/src/core/utils/validators.dart';

void main() {
  test('email validator', () {
    expect(Validators.email('user@example.com'), isNull);
    expect(Validators.email('invalid'), 'invalid');
  });

  test('password validator', () {
    expect(Validators.password('Pass1234'), isNull);
    expect(Validators.password('short'), 'min_length');
    expect(Validators.password('password'), 'number');
  });

  test('confirm password validator', () {
    expect(Validators.confirmPassword('Pass1234', 'Pass1234'), isNull);
    expect(Validators.confirmPassword('Pass1234', 'Another'), 'mismatch');
  });

  test('price validator', () {
    expect(Validators.price('42'), isNull);
    expect(Validators.price('-1'), 'invalid');
  });
}
