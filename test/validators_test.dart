import 'package:flutter_auth_base/core/utils/password_strength.dart';
import 'package:flutter_auth_base/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejeita vazio e formato inválido', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('joao'), isNotNull);
      expect(Validators.email('joao@'), isNotNull);
      expect(Validators.email('joao@site'), isNotNull);
    });

    test('aceita e-mail válido (com espaços nas pontas)', () {
      expect(Validators.email(' joao.silva+app@site.com.br '), isNull);
    });
  });

  group('Validators.newPassword', () {
    test('exige 8 caracteres, letras e números', () {
      expect(Validators.newPassword(''), isNotNull);
      expect(Validators.newPassword('abc12'), isNotNull);
      expect(Validators.newPassword('abcdefgh'), isNotNull);
      expect(Validators.newPassword('12345678'), isNotNull);
      expect(Validators.newPassword('senha123'), isNull);
    });
  });

  test('Validators.confirmPassword compara com a senha original', () {
    final validate = Validators.confirmPassword(() => 'senha123');
    expect(validate(''), isNotNull);
    expect(validate('outra123'), 'As senhas não coincidem.');
    expect(validate('senha123'), isNull);
  });

  test('Validators.name', () {
    expect(Validators.name('  '), isNotNull);
    expect(Validators.name('A'), isNotNull);
    expect(Validators.name('Ana'), isNull);
  });

  test('PasswordStrength', () {
    expect(PasswordStrength.of(''), PasswordStrength.empty);
    expect(PasswordStrength.of('abc'), PasswordStrength.weak);
    expect(PasswordStrength.of('Senha123'), PasswordStrength.medium);
    expect(PasswordStrength.of('Senha@Forte123'), PasswordStrength.strong);
  });
}
