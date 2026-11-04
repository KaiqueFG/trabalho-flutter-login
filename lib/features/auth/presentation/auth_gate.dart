import 'package:flutter/material.dart';

import '../../home/presentation/home_page.dart';
import '../data/auth_repository.dart';
import 'auth_scope.dart';
import 'pages/login_page.dart';

/// Decide qual tela mostrar de acordo com o estado de autenticação.
///
/// Mantém a sessão: se o usuário já estiver logado ao abrir o app,
/// vai direto para a Home.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Stream<AppUser?>? _authState;

  /// Usuário cuja sessão foi restaurada ao abrir o app (não fez login agora).
  String? _restoredUid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_authState == null) {
      final repository = AuthScope.of(context);
      _restoredUid = repository.currentUser?.uid;
      _authState = repository.authStateChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: _authState,
      initialData: AuthScope.of(context).currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        // Depois de sair, o próximo acesso é um login novo.
        if (user == null) _restoredUid = null;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: user == null
              ? const LoginPage(key: ValueKey('login'))
              : HomePage(
                  key: ValueKey(user.uid),
                  user: user,
                  showLoginSuccess: user.uid != _restoredUid,
                ),
        );
      },
    );
  }
}
