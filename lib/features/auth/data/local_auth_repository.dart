import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/validators.dart';
import 'auth_repository.dart';

/// Autenticação local que reproduz o comportamento do Firebase Auth
/// (e-mail/senha).
///
/// Os dados do usuário ficam salvos no aparelho com o SharedPreferences.
/// Como esse armazenamento é limitado, só um usuário é guardado: cada novo
/// cadastro substitui o anterior. A senha nunca é gravada: guarda-se apenas
/// o hash SHA-256 da senha combinada com um salt aleatório.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository._(this._prefs, this.latency) {
    _currentUser = _restoreSession();
  }

  /// Carrega o usuário e a sessão salvos no aparelho.
  static Future<LocalAuthRepository> create({
    Duration latency = const Duration(milliseconds: 700),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    // Versões anteriores guardavam várias contas nesta chave.
    await prefs.remove('auth.accounts');
    return LocalAuthRepository._(prefs, latency);
  }

  static const _userKey = 'auth.user';
  static const _sessionKey = 'auth.session';

  final SharedPreferences _prefs;

  /// Atraso artificial que imita o tempo de resposta de um servidor.
  final Duration latency;

  /// Tentativas de senha errada antes de bloquear o login temporariamente.
  static const maxFailedAttempts = 5;
  static const lockDuration = Duration(seconds: 30);

  final _failedAttempts = <String, int>{};
  final _lockedUntil = <String, DateTime>{};
  final _controller = StreamController<AppUser?>.broadcast();
  final _random = Random.secure();
  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) async {
    await Future<void>.delayed(latency);
    final key = _normalize(email);

    final lockedUntil = _lockedUntil[key];
    if (lockedUntil != null && DateTime.now().isBefore(lockedUntil)) {
      throw const AuthException(AuthErrorCode.tooManyRequests);
    }

    final account = _findAccount(key);
    if (account == null || account.passwordHash != _hash(password, account.salt)) {
      final attempts = (_failedAttempts[key] ?? 0) + 1;
      if (attempts >= maxFailedAttempts) {
        _failedAttempts.remove(key);
        _lockedUntil[key] = DateTime.now().add(lockDuration);
        throw const AuthException(AuthErrorCode.tooManyRequests);
      }
      _failedAttempts[key] = attempts;
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }
    _failedAttempts.remove(key);
    _lockedUntil.remove(key);
    if (!account.emailVerified) {
      throw const AuthException(AuthErrorCode.emailNotVerified);
    }
    await _prefs.setString(_sessionKey, account.email);
    final user = account.toUser();
    _emit(user);
    return user;
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);
    final key = _normalize(email);
    if (Validators.email(key) != null) {
      throw const AuthException(AuthErrorCode.invalidEmail);
    }
    // Mesma regra mínima do Firebase Auth.
    if (password.length < 6) {
      throw const AuthException(AuthErrorCode.weakPassword);
    }

    final salt = _newSalt();
    final account = _Account(
      uid: 'user-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      email: key,
      salt: salt,
      passwordHash: _hash(password, salt),
      emailVerified: false,
    );
    // O novo cadastro substitui o usuário anterior e encerra a sessão dele.
    await _writeAccount(account);
    await _prefs.remove(_sessionKey);
    _failedAttempts.clear();
    _lockedUntil.clear();
    if (_currentUser != null) _emit(null);
    return account.toUser();
  }

  @override
  Future<void> verifyEmail(String email) async {
    final account = _findAccount(_normalize(email));
    if (account == null) throw const AuthException(AuthErrorCode.unknown);
    await _writeAccount(account.copyWith(emailVerified: true));
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(latency);
    if (Validators.email(email) != null) {
      throw const AuthException(AuthErrorCode.invalidEmail);
    }
    if (_findAccount(_normalize(email)) == null) {
      throw const AuthException(AuthErrorCode.userNotFound);
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String email,
    required String newPassword,
  }) async {
    await Future<void>.delayed(latency);
    final key = _normalize(email);
    final account = _findAccount(key);
    if (account == null) throw const AuthException(AuthErrorCode.userNotFound);
    if (newPassword.length < 6) {
      throw const AuthException(AuthErrorCode.weakPassword);
    }
    if (_hash(newPassword, account.salt) == account.passwordHash) {
      throw const AuthException(AuthErrorCode.samePassword);
    }
    final salt = _newSalt();
    await _writeAccount(account.copyWith(salt: salt, passwordHash: _hash(newPassword, salt)));
    // Senha nova: libera o login caso estivesse bloqueado.
    _failedAttempts.remove(key);
    _lockedUntil.remove(key);
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove(_sessionKey);
    _emit(null);
  }

  AppUser? _restoreSession() {
    final email = _prefs.getString(_sessionKey);
    if (email == null) return null;
    return _findAccount(email)?.toUser();
  }

  void _emit(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
  }

  /// Usuário salvo no aparelho, se o e-mail for o dele.
  _Account? _findAccount(String email) {
    final raw = _prefs.getString(_userKey);
    if (raw == null) return null;
    final account = _Account.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return account.email == email ? account : null;
  }

  Future<void> _writeAccount(_Account account) =>
      _prefs.setString(_userKey, jsonEncode(account.toJson()));

  String _newSalt() => base64Url.encode(List<int>.generate(16, (_) => _random.nextInt(256)));

  static String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  static String _normalize(String email) => email.trim().toLowerCase();
}

/// Dados do usuário como ficam salvos no aparelho.
class _Account {
  const _Account({
    required this.uid,
    required this.name,
    required this.email,
    required this.salt,
    required this.passwordHash,
    required this.emailVerified,
  });

  factory _Account.fromJson(Map<String, dynamic> json) => _Account(
        uid: json['uid'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        salt: json['salt'] as String,
        passwordHash: json['passwordHash'] as String,
        emailVerified: json['emailVerified'] as bool,
      );

  final String uid;
  final String name;
  final String email;
  final String salt;
  final String passwordHash;
  final bool emailVerified;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'salt': salt,
        'passwordHash': passwordHash,
        'emailVerified': emailVerified,
      };

  _Account copyWith({bool? emailVerified, String? salt, String? passwordHash}) => _Account(
        uid: uid,
        name: name,
        email: email,
        salt: salt ?? this.salt,
        passwordHash: passwordHash ?? this.passwordHash,
        emailVerified: emailVerified ?? this.emailVerified,
      );

  AppUser toUser() => AppUser(
        uid: uid,
        email: email,
        displayName: name,
        emailVerified: emailVerified,
      );
}
