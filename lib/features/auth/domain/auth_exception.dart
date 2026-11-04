/// Erros de autenticação conhecidos pela aplicação.
///
/// Os códigos seguem o modelo do Firebase Auth para e-mail/senha.
enum AuthErrorCode {
  invalidEmail,
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  emailNotVerified,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.code);

  final AuthErrorCode code;

  /// Mensagem amigável em português, pronta para exibir ao usuário.
  String get message => switch (code) {
        AuthErrorCode.invalidEmail => 'O e-mail informado é inválido.',
        // Mensagem genérica de propósito: não revela se o e-mail existe.
        AuthErrorCode.invalidCredentials => 'E-mail ou senha incorretos.',
        AuthErrorCode.emailAlreadyInUse => 'Já existe uma conta com este e-mail.',
        AuthErrorCode.weakPassword => 'A senha é muito fraca.',
        AuthErrorCode.emailNotVerified =>
          'Confirme seu e-mail antes de entrar.',
        AuthErrorCode.unknown => 'Algo deu errado. Tente novamente.',
      };

  @override
  String toString() => 'AuthException($code)';
}
