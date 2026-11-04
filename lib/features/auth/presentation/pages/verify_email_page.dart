import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/auth_repository.dart';
import '../auth_scope.dart';
import '../widgets/auth_layout.dart';

/// Tela de verificação de e-mail exibida após o cadastro.
///
/// Simula o usuário abrindo o link de confirmação: depois de
/// [verificationDelay] a conta é marcada como verificada e o usuário
/// é convidado a voltar para o login.
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, required this.email});

  static const verificationDelay = Duration(seconds: 5);

  final String email;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;
  bool _verified = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _timer = Timer(VerifyEmailPage.verificationDelay, _verify);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verify() async {
    try {
      await AuthScope.of(context).verifyEmail(widget.email);
      if (mounted) setState(() => _verified = true);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _goToLogin() => Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final finished = _verified || _error != null;

    return PopScope(
      // Durante a verificação o usuário não volta por engano.
      canPop: finished,
      child: AuthLayout(
        icon: _verified ? Icons.mark_email_read_rounded : Icons.mark_email_unread_rounded,
        title: _verified ? 'E-mail verificado!' : 'Verifique seu e-mail',
        subtitle: _verified
            ? 'Seu e-mail foi verificado com sucesso. Agora é só entrar com seu e-mail e senha.'
            : 'Enviamos um link de confirmação para o endereço abaixo.',
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _verified
              ? _VerifiedContent(key: const ValueKey('ok'), onContinue: _goToLogin)
              : _PendingContent(
                  key: const ValueKey('pending'),
                  email: widget.email,
                  error: _error,
                  onBack: _goToLogin,
                ),
        ),
      ),
    );
  }
}

class _PendingContent extends StatelessWidget {
  const _PendingContent({
    super.key,
    required this.email,
    required this.onBack,
    this.error,
  });

  final String email;
  final String? error;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.alternate_email_rounded, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    email,
                    style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        if (error == null) ...[
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 16),
          Text(
            'Aguardando a confirmação do seu e-mail...',
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ] else ...[
          Text(
            error!,
            textAlign: TextAlign.center,
            style: text.bodyLarge?.copyWith(color: scheme.error),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onBack, child: const Text('Voltar para o login')),
        ],
      ],
    );
  }
}

class _VerifiedContent extends StatelessWidget {
  const _VerifiedContent({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    const success = Color(0xFF16A34A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.4, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, size: 56, color: success),
            ),
          ),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: onContinue,
          icon: const Icon(Icons.login_rounded),
          label: const Text('Ir para o login'),
        ),
      ],
    );
  }
}
