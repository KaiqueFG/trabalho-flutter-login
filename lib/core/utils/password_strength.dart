enum PasswordStrength {
  empty(0, 'Digite uma senha'),
  weak(1, 'Fraca'),
  medium(2, 'Média'),
  strong(3, 'Forte');

  const PasswordStrength(this.level, this.label);

  final int level;
  final String label;

  static PasswordStrength of(String password) {
    if (password.isEmpty) return PasswordStrength.empty;
    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
}
