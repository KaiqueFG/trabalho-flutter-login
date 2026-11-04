import 'package:flutter_auth_base/features/auth/data/auth_repository.dart';
import 'package:flutter_auth_base/features/auth/data/local_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const email = 'ana@teste.com';
  const password = 'senha123';

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<LocalAuthRepository> newRepository() =>
      LocalAuthRepository.create(latency: Duration.zero);

  test('cadastro cria conta não verificada e não inicia sessão', () async {
    final repo = await newRepository();
    final user = await repo.register(name: 'Ana', email: email, password: password);

    expect(user.emailVerified, isFalse);
    expect(repo.currentUser, isNull);
  });

  test('não permite e-mail duplicado (ignora maiúsculas)', () async {
    final repo = await newRepository();
    await repo.register(name: 'Ana', email: email, password: password);

    expect(
      () => repo.register(name: 'Ana', email: 'ANA@teste.com', password: password),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', AuthErrorCode.emailAlreadyInUse)),
    );
  });

  test('login exige e-mail verificado', () async {
    final repo = await newRepository();
    await repo.register(name: 'Ana', email: email, password: password);

    expect(
      () => repo.signIn(email: email, password: password),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', AuthErrorCode.emailNotVerified)),
    );
  });

  test('senha errada retorna credenciais inválidas', () async {
    final repo = await newRepository();
    await repo.register(name: 'Ana', email: email, password: password);
    await repo.verifyEmail(email);

    expect(
      () => repo.signIn(email: email, password: 'errada123'),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', AuthErrorCode.invalidCredentials)),
    );
  });

  test('conta e sessão continuam salvas ao reabrir o app', () async {
    final first = await newRepository();
    await first.register(name: 'Ana', email: email, password: password);
    await first.verifyEmail(email);
    await first.signIn(email: email, password: password);

    final reopened = await newRepository();
    expect(reopened.currentUser?.email, email);

    await reopened.signOut();
    final afterLogout = await newRepository();
    expect(afterLogout.currentUser, isNull);
    expect((await afterLogout.signIn(email: email, password: password)).email, email);
  });

  test('redefinir senha troca a senha de acesso', () async {
    final repo = await newRepository();
    await repo.register(name: 'Ana', email: email, password: password);
    await repo.verifyEmail(email);
    await repo.confirmPasswordReset(email: email, newPassword: 'novaSenha1');

    expect(
      () => repo.signIn(email: email, password: password),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', AuthErrorCode.invalidCredentials)),
    );
    expect((await repo.signIn(email: email, password: 'novaSenha1')).email, email);
  });

  test('redefinir senha de e-mail inexistente avisa que não há conta', () async {
    final repo = await newRepository();
    expect(
      () => repo.confirmPasswordReset(email: 'nao@existe.com', newPassword: 'novaSenha1'),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', AuthErrorCode.userNotFound)),
    );
  });

  test('a senha não é salva em texto puro', () async {
    final repo = await newRepository();
    await repo.register(name: 'Ana', email: email, password: password);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('auth.accounts'), isNot(contains(password)));
  });
}
