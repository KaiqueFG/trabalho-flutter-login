import 'package:flutter/material.dart';

import '../../../core/utils/snackbar.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/auth_scope.dart';

/// Tela principal, exibida após o login.
///
/// O conteúdo fica em branco nesta etapa; a navegação é feita pelo menu
/// lateral (drawer).
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user, this.showLoginSuccess = true});

  final AppUser user;

  /// Exibe o aviso de sucesso apenas logo após o login.
  final bool showLoginSuccess;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.showLoginSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.showSnack('Login realizado com sucesso!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: _AppDrawer(user: widget.user),
      body: const SizedBox.expand(),
    );
  }
}

/// Menu lateral com os dados do usuário e as opções do app.
class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: scheme.primary),
            accountName: Text('Olá, ${user.greetingName}!'),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: scheme.onPrimary,
              child: Text(
                user.initial,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Início'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              AuthScope.of(context).signOut();
            },
          ),
          SizedBox(height: 8 + MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
