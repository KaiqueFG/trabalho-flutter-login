import '../domain/app_user.dart';

export '../domain/app_user.dart';
export '../domain/auth_exception.dart';

/// Contrato de autenticação usado pela camada de apresentação.
///
/// Segue os métodos do Firebase Auth (e-mail/senha), o que permite trocar
/// a implementação local por um backend real sem alterar as telas.
/// Todas as falhas são lançadas como `AuthException`.
abstract interface class AuthRepository {
  /// Emite o usuário atual e cada mudança (login e logout).
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  /// Entra com e-mail e senha. Exige que o e-mail já esteja verificado.
  Future<AppUser> signIn({required String email, required String password});

  /// Cria a conta com o e-mail ainda não verificado. Não inicia sessão.
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });

  /// Confirma o e-mail da conta (equivale a clicar no link de verificação).
  Future<void> verifyEmail(String email);

  Future<void> sendPasswordReset(String email);

  /// Define a nova senha da conta (equivale a abrir o link de redefinição).
  Future<void> confirmPasswordReset({
    required String email,
    required String newPassword,
  });

  Future<void> signOut();
}
