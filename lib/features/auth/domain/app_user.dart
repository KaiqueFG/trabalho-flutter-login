/// Usuário autenticado, independente de onde as contas são armazenadas.
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.emailVerified = false,
  });

  final String uid;
  final String email;
  final String? displayName;
  final bool emailVerified;

  /// Nome para exibição, com fallback para a parte local do e-mail.
  String get greetingName {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name.split(' ').first;
    return email.split('@').first;
  }

  /// Inicial para o avatar (nunca vazia).
  String get initial {
    final name = greetingName;
    return name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
  }
}
