import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../data/auth_repository.dart';
import '../auth_scope.dart';
import '../widgets/auth_layout.dart';
import '../widgets/forgot_password_dialog.dart';
import 'verify_email_page.dart';

/// Tela de login (modelo do `signInWithEmailAndPassword` do Firebase Auth).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await AuthScope.of(context).signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Sucesso: o AuthGate troca automaticamente para a Home.
    } on AuthException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, isError: true);
      // Conta ainda não confirmada: volta para a verificação de e-mail.
      if (e.code == AuthErrorCode.emailNotVerified) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => VerifyEmailPage(email: _emailController.text.trim()),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      icon: Icons.lock_outline_rounded,
      title: 'Bem-vindo de volta',
      subtitle: 'Entre com seu e-mail e senha para continuar.',
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _emailController,
                label: 'E-mail',
                hint: 'voce@exemplo.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
                enabled: !_loading,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: 'Senha',
                icon: Icons.key_outlined,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: Validators.password,
                enabled: !_loading,
                onSubmitted: (_) => _submit(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _loading
                      ? null
                      : () => showForgotPasswordDialog(
                            context,
                            email: _emailController.text.trim(),
                          ),
                  child: const Text('Esqueci minha senha'),
                ),
              ),
              const SizedBox(height: 8),
              LoadingButton(
                label: 'Entrar',
                loading: _loading,
                onPressed: _submit,
              ),
              const SizedBox(height: 24),
              AuthFooterLink(
                question: 'Não tem uma conta?',
                action: 'Cadastre-se',
                onPressed:
                    _loading ? null : () => Navigator.of(context).pushNamed(AppRoutes.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
