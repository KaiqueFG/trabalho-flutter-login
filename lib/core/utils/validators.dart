/// Validações de formulário reutilizáveis (retornam a mensagem de erro ou null).
abstract final class Validators {
  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final _letter = RegExp(r'[A-Za-zÀ-ÿ]');
  static final _digit = RegExp(r'\d');
  // Letras (com acento), espaços, hífen e apóstrofo: "Ana-Maria", "D'Ávila".
  static final _nameRegex = RegExp(r"^[A-Za-zÀ-ÿ' -]+$");

  static const minPasswordLength = 8;
  static const maxNameLength = 60;
  static const maxEmailLength = 100;
  static const maxPasswordLength = 64;

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe seu nome.';
    if (v.length < 2) return 'Nome muito curto.';
    if (v.length > maxNameLength) return 'Nome muito longo.';
    if (!_nameRegex.hasMatch(v)) return 'Use apenas letras no nome.';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe seu e-mail.';
    if (v.length > maxEmailLength) return 'E-mail muito longo.';
    if (!_emailRegex.hasMatch(v)) return 'E-mail inválido.';
    return null;
  }

  /// Usado no login: só exige que a senha seja preenchida.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha.';
    return null;
  }

  /// Usado no cadastro: aplica a política de senha do app.
  static String? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Crie uma senha.';
    if (v.length < minPasswordLength) {
      return 'A senha deve ter pelo menos $minPasswordLength caracteres.';
    }
    if (v.length > maxPasswordLength) {
      return 'A senha deve ter no máximo $maxPasswordLength caracteres.';
    }
    if (!_letter.hasMatch(v) || !_digit.hasMatch(v)) {
      return 'Use letras e números.';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return 'Confirme sua senha.';
      if (value != original()) return 'As senhas não coincidem.';
      return null;
    };
  }
}
