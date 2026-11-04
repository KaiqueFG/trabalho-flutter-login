// Testes do ponto de vista de um usuário comum, cobrindo os erros mais
// prováveis de digitação e de uso em cada tela.
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/app/app.dart';
import 'package:flutter_auth_base/features/auth/data/local_auth_repository.dart';
import 'package:flutter_auth_base/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flutter_auth_base/features/auth/presentation/pages/verify_email_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalAuthRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await LocalAuthRepository.create(latency: Duration.zero);
  });

  Future<void> pumpApp(WidgetTester tester, [LocalAuthRepository? repo]) async {
    await tester.pumpWidget(App(authRepository: repo ?? repository));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String text, {bool settle = true}) async {
    final finder = find.text(text).last;
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }
  }

  Future<void> fill(WidgetTester tester, String label, String value) async {
    // .last: com a janela de recuperação aberta, o campo dela fica por cima.
    final field = find.widgetWithText(TextFormField, label).last;
    await tester.ensureVisible(field);
    await tester.enterText(field, value);
    await tester.pump();
  }

  Future<void> createVerifiedAccount(WidgetTester tester) async {
    await tester.runAsync(() async {
      await repository.register(
          name: 'Maria Souza', email: 'maria@teste.com', password: 'senha123');
      await repository.verifyEmail('maria@teste.com');
    });
  }

  Future<void> login(WidgetTester tester, String email, String password) async {
    await fill(tester, 'E-mail', email);
    await fill(tester, 'Senha', password);
    await tap(tester, 'Entrar');
  }

  group('Cadastro', () {
    Future<void> openRegister(WidgetTester tester) async {
      await pumpApp(tester);
      await tap(tester, 'Cadastre-se');
    }

    testWidgets('formulário vazio mostra todos os erros', (tester) async {
      await openRegister(tester);
      await tap(tester, 'Criar conta');

      expect(find.text('Informe seu nome.'), findsOneWidget);
      expect(find.text('Informe seu e-mail.'), findsOneWidget);
      expect(find.text('Crie uma senha.'), findsOneWidget);
      expect(find.text('Confirme sua senha.'), findsOneWidget);
    });

    testWidgets('nome com números é recusado', (tester) async {
      await openRegister(tester);
      await fill(tester, 'Nome completo', 'Maria123');
      expect(find.text('Use apenas letras no nome.'), findsOneWidget);
    });

    testWidgets('nome com acento e hífen é aceito', (tester) async {
      await openRegister(tester);
      await fill(tester, 'Nome completo', "Ana-Júlia D'Ávila");
      expect(find.text('Use apenas letras no nome.'), findsNothing);
    });

    testWidgets('e-mail sem domínio é recusado', (tester) async {
      await openRegister(tester);
      await fill(tester, 'E-mail', 'maria@');
      expect(find.text('E-mail inválido.'), findsOneWidget);
    });

    testWidgets('senha só com letras é recusada', (tester) async {
      await openRegister(tester);
      await fill(tester, 'Senha', 'abcdefgh');
      expect(find.text('Use letras e números.'), findsOneWidget);
    });

    testWidgets('e-mail já cadastrado não cria outra conta', (tester) async {
      await createVerifiedAccount(tester);
      await openRegister(tester);

      await fill(tester, 'Nome completo', 'Outra Maria');
      await fill(tester, 'E-mail', 'MARIA@teste.com');
      await fill(tester, 'Senha', 'outra123');
      await fill(tester, 'Confirmar senha', 'outra123');
      await tap(tester, 'Criar conta');

      expect(find.text('Já existe uma conta com este e-mail.'), findsOneWidget);
      expect(find.text('Verifique seu e-mail'), findsNothing);
    });

    testWidgets('voltar do cadastro leva ao login', (tester) async {
      await openRegister(tester);
      await tap(tester, 'Entrar');
      expect(find.text('Bem-vindo de volta'), findsOneWidget);
    });
  });

  group('Verificação de e-mail', () {
    testWidgets('não deixa sair da tela antes de verificar', (tester) async {
      await pumpApp(tester);
      await tap(tester, 'Cadastre-se');
      await fill(tester, 'Nome completo', 'Maria Souza');
      await fill(tester, 'E-mail', 'maria@teste.com');
      await fill(tester, 'Senha', 'senha123');
      await fill(tester, 'Confirmar senha', 'senha123');
      await tap(tester, 'Criar conta', settle: false);

      // Botão "voltar" do Android durante a verificação.
      await tester.binding.handlePopRoute();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Verifique seu e-mail'), findsOneWidget);

      await tester.pump(VerifyEmailPage.verificationDelay);
      await tester.pumpAndSettle();
      expect(find.text('E-mail verificado!'), findsOneWidget);
    });
  });

  group('Login', () {
    testWidgets('e-mail com maiúsculas e espaços funciona', (tester) async {
      await createVerifiedAccount(tester);
      await pumpApp(tester);
      await login(tester, '  MARIA@Teste.com ', 'senha123');
      expect(find.text('Login realizado com sucesso!'), findsOneWidget);
    });

    testWidgets('senha com letra maiúscula diferente é recusada', (tester) async {
      await createVerifiedAccount(tester);
      await pumpApp(tester);
      await login(tester, 'maria@teste.com', 'SENHA123');
      expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
    });

    testWidgets('bloqueia após 5 senhas erradas, mesmo com a senha certa', (tester) async {
      await createVerifiedAccount(tester);
      await pumpApp(tester);

      for (var i = 0; i < LocalAuthRepository.maxFailedAttempts; i++) {
        await login(tester, 'maria@teste.com', 'errada$i');
      }
      expect(find.textContaining('Muitas tentativas erradas'), findsOneWidget);

      await login(tester, 'maria@teste.com', 'senha123');
      expect(find.text('Login realizado com sucesso!'), findsNothing);
    });

    testWidgets('mostrar/ocultar senha', (tester) async {
      await pumpApp(tester);
      await fill(tester, 'Senha', 'senha123');

      EditableText field() => tester.widget<EditableText>(
            find.descendant(
              of: find.widgetWithText(TextFormField, 'Senha'),
              matching: find.byType(EditableText),
            ),
          );

      expect(field().obscureText, isTrue);
      await tester.tap(find.byTooltip('Mostrar senha'));
      await tester.pump();
      expect(field().obscureText, isFalse);
    });
  });

  group('Sessão', () {
    testWidgets('reabrir o app mantém logado sem repetir o aviso de login', (tester) async {
      await createVerifiedAccount(tester);
      await tester.runAsync(
        () => repository.signIn(email: 'maria@teste.com', password: 'senha123'),
      );

      // Simula fechar e abrir o app.
      final reopened = await tester.runAsync(
        () => LocalAuthRepository.create(latency: Duration.zero),
      );
      await pumpApp(tester, reopened);

      expect(find.text('Olá, Maria!'), findsOneWidget);
      expect(find.text('Login realizado com sucesso!'), findsNothing);
    });

    testWidgets('sair pelo ícone da barra superior', (tester) async {
      await createVerifiedAccount(tester);
      await pumpApp(tester);
      await login(tester, 'maria@teste.com', 'senha123');

      await tester.tap(find.byTooltip('Sair'));
      await tester.pumpAndSettle();
      expect(find.text('Bem-vindo de volta'), findsOneWidget);
    });
  });

  group('Esqueci minha senha', () {
    Future<void> openNewPasswordForm(WidgetTester tester) async {
      await createVerifiedAccount(tester);
      await pumpApp(tester);
      await fill(tester, 'E-mail', 'maria@teste.com');
      await tap(tester, 'Esqueci minha senha');
      await tap(tester, 'Enviar link', settle: false);
      await tester.pump(ResetPasswordPage.linkDelay);
      await tester.pumpAndSettle();
    }

    testWidgets('cancelar fecha a janela', (tester) async {
      await pumpApp(tester);
      await tap(tester, 'Esqueci minha senha');
      await tap(tester, 'Cancelar');
      expect(find.text('Recuperar senha'), findsNothing);
    });

    testWidgets('e-mail inválido não envia', (tester) async {
      await pumpApp(tester);
      await tap(tester, 'Esqueci minha senha');
      await fill(tester, 'E-mail', 'maria@');
      await tap(tester, 'Enviar link');
      expect(find.text('E-mail inválido.'), findsWidgets);
      expect(find.text('Recuperar senha'), findsOneWidget);
    });

    testWidgets('nova senha igual à atual é recusada', (tester) async {
      await openNewPasswordForm(tester);
      await fill(tester, 'Nova senha', 'senha123');
      await fill(tester, 'Confirmar nova senha', 'senha123');
      await tap(tester, 'Salvar nova senha');

      expect(find.text('A nova senha deve ser diferente da atual.'), findsOneWidget);
      expect(find.text('Senha alterada!'), findsNothing);
    });

    testWidgets('confirmação diferente é recusada', (tester) async {
      await openNewPasswordForm(tester);
      await fill(tester, 'Nova senha', 'novaSenha1');
      await fill(tester, 'Confirmar nova senha', 'outraSenha1');
      await tap(tester, 'Salvar nova senha');
      expect(find.text('As senhas não coincidem.'), findsOneWidget);
    });
  });
}
