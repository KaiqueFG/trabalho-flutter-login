import 'package:flutter/material.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/auth_scope.dart';

/// Tela exibida após o login.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.user, this.showLoginSuccess = true});

  final AppUser user;

  /// Exibe o aviso de sucesso apenas logo após o login.
  final bool showLoginSuccess;

  static const _success = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => AuthScope.of(context).signOut(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showLoginSuccess) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: _success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: _success),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Login realizado com sucesso!',
                            style: text.titleSmall?.copyWith(
                              color: _success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: scheme.primaryContainer,
                          child: Text(
                            user.initial,
                            style: text.headlineMedium?.copyWith(
                              color: scheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Olá, ${user.greetingName}!',
                          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        const Chip(
                          avatar: Icon(Icons.verified_rounded, size: 18, color: _success),
                          label: Text('E-mail verificado'),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text('Sair da conta'),
                            onPressed: () => AuthScope.of(context).signOut(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
