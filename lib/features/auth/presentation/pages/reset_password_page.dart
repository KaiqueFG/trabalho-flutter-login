import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../data/auth_repository.dart';
import '../auth_scope.dart';
import '../widgets/auth_layout.dart';
import '../widgets/password_strength_bar.dart';

enum _Step { waiting, form, done }

/// Redefinição de senha.
///
/// Simula o usuário abrindo o link enviado por e-mail: depois de
/// [linkDelay] aparece o formulário para criar a nova senha.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email});

  static const linkDelay = Duration(seconds: 5);

  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  Timer? _timer;
  _Step _step = _Step.waiting;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(ResetPasswordPage.linkDelay, () {
      if (mounted) setState(() => _step = _Step.form);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await AuthScope.of(context).confirmPasswordReset(
        email: widget.email,
        newPassword: _passwordController.text,
      );
      if (mounted) setState(() => _step = _Step.done);
    } on AuthException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToLogin() => Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (_step) {
      _Step.waiting => (
          Icons.forward_to_inbox_rounded,
          'Verifique seu e-mail',
          'Enviamos um link para redefinir a senha de ${widget.email}.',
        ),
      _Step.form => (
          Icons.lock_reset_rounded,
          'Crie uma nova senha',
          'Digite a nova senha da conta ${widget.email}.',
        ),
      _Step.done => (
          Icons.check_circle_rounded,
          'Senha alterada!',
          'Sua senha foi redefinida com sucesso. Agora é só entrar com a nova senha.',
        ),
    };

    return AuthLayout(
      showBackButton: _step != _Step.done,
      icon: icon,
      title: title,
      subtitle: subtitle,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: switch (_step) {
          _Step.waiting => const _Waiting(key: ValueKey('waiting')),
          _Step.form => _buildForm(),
          _Step.done => FilledButton.icon(
              key: const ValueKey('done'),
              onPressed: _goToLogin,
              icon: const Icon(Icons.login_rounded),
              label: const Text('Ir para o login'),
            ),
        },
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _passwordController,
            label: 'Nova senha',
            hint: 'Mínimo de ${Validators.minPasswordLength} caracteres',
            icon: Icons.key_outlined,
            isPassword: true,
            autofillHints: const [AutofillHints.newPassword],
            validator: Validators.newPassword,
            enabled: !_loading,
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _passwordController,
            builder: (_, value, __) => PasswordStrengthBar(password: value.text),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _confirmController,
            label: 'Confirmar nova senha',
            icon: Icons.key_outlined,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: Validators.confirmPassword(() => _passwordController.text),
            enabled: !_loading,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 28),
          LoadingButton(label: 'Salvar nova senha', loading: _loading, onPressed: _save),
        ],
      ),
    );
  }
}

class _Waiting extends StatelessWidget {
  const _Waiting({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Aguardando você abrir o link...',
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
