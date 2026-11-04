import 'package:flutter/material.dart';

import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../data/auth_repository.dart';
import '../auth_scope.dart';
import '../widgets/auth_layout.dart';
import '../widgets/password_strength_bar.dart';
import 'verify_email_page.dart';

/// Tela de cadastro (modelo do `createUserWithEmailAndPassword` do Firebase Auth).
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final user = await AuthScope.of(context).register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      // Conta criada: segue para a confirmação do e-mail.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => VerifyEmailPage(email: user.email)),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, isError: true);
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      showBackButton: true,
      icon: Icons.person_add_alt_1_rounded,
      title: 'Criar conta',
      subtitle: 'Preencha seus dados para começar.',
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Nome completo',
                icon: Icons.badge_outlined,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                validator: Validators.name,
                enabled: !_loading,
              ),
              const SizedBox(height: 16),
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
                label: 'Confirmar senha',
                icon: Icons.key_outlined,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: Validators.confirmPassword(() => _passwordController.text),
                enabled: !_loading,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 28),
              LoadingButton(
                label: 'Criar conta',
                loading: _loading,
                onPressed: _submit,
              ),
              const SizedBox(height: 24),
              AuthFooterLink(
                question: 'Já tem uma conta?',
                action: 'Entrar',
                onPressed: _loading ? null : () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
