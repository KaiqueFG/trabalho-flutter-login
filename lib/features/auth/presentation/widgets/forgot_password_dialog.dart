import 'package:flutter/material.dart';

import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/auth_repository.dart';
import '../auth_scope.dart';
import '../pages/reset_password_page.dart';

/// Abre o diálogo de recuperação de senha (modelo do `sendPasswordResetEmail` do Firebase Auth).
Future<void> showForgotPasswordDialog(BuildContext context, {String? email}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _ForgotPasswordDialog(initialEmail: email ?? ''),
  );
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(text: widget.initialEmail);
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final email = _emailController.text.trim();
      await AuthScope.of(context).sendPasswordReset(email);
      if (!mounted) return;
      final navigator = Navigator.of(context)..pop();
      // Segue para a tela que simula a abertura do link enviado por e-mail.
      navigator.push(
        MaterialPageRoute<void>(builder: (_) => ResetPasswordPage(email: email)),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, isError: true);
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.lock_reset_rounded),
      title: const Text('Recuperar senha'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Informe o e-mail da sua conta. Enviaremos um link para criar uma nova senha.',
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _emailController,
              label: 'E-mail',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
              enabled: !_loading,
              onSubmitted: (_) => _send(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _loading ? null : _send,
          child: _loading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enviar link'),
        ),
      ],
    );
  }
}
