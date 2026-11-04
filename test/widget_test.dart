import 'package:flutter/material.dart';
import 'package:flutter_auth_base/app/app.dart';
import 'package:flutter_auth_base/features/auth/data/local_auth_repository.dart';
import 'package:flutter_auth_base/features/auth/presentation/pages/verify_email_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalAuthRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await LocalAuthRepository.create(latency: Duration.zero);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(App(authRepository: repository));
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
    final field = find.widgetWithText(TextFormField, label);
    await tester.ensureVisible(field);
    await tester.enterText(field, value);
  }

  Future<void> register(WidgetTester tester) async {
    await tap(tester, 'Cadastre-se');
    await fill(tester, 'Nome completo', 'Maria Souza');
    await fill(tester, 'E-mail', 'maria@teste.com');
    await fill(tester, 'Senha', 'senha123');
    await fill(tester, 'Confirmar senha', 'senha123');
    // A tela de verificação tem um indicador animado: não usar pumpAndSettle.
    await tap(tester, 'Criar conta', settle: false);
  }

  Future<void> login(WidgetTester tester) async {
    await fill(tester, 'E-mail', 'maria@teste.com');
    await fill(tester, 'Senha', 'senha123');
    await tap(tester, 'Entrar');
  }

  testWidgets('abre na tela de login', (tester) async {
    await pumpApp(tester);
    expect(find.text('Bem-vindo de volta'), findsOneWidget);
  });

  testWidgets('login valida campos obrigatórios', (tester) async {
    await pumpApp(tester);
    await tap(tester, 'Entrar');
    expect(find.text('Informe seu e-mail.'), findsOneWidget);
    expect(find.text('Informe sua senha.'), findsOneWidget);
  });

  testWidgets('login com credenciais erradas mostra erro', (tester) async {
    await pumpApp(tester);
    await fill(tester, 'E-mail', 'ninguem@teste.com');
    await fill(tester, 'Senha', 'qualquer1');
    await tap(tester, 'Entrar');
    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
  });

  testWidgets('cadastro → verificação → login → tela de sucesso → logout', (tester) async {
    await pumpApp(tester);
    await register(tester);

    expect(find.text('Verifique seu e-mail'), findsOneWidget);
    expect(find.text('maria@teste.com'), findsOneWidget);

    await tester.pump(VerifyEmailPage.verificationDelay);
    await tester.pumpAndSettle();
    expect(find.text('E-mail verificado!'), findsOneWidget);

    await tap(tester, 'Ir para o login');
    expect(find.text('Bem-vindo de volta'), findsOneWidget);

    await login(tester);
    expect(find.text('Login realizado com sucesso!'), findsOneWidget);
    expect(find.text('Olá, Maria!'), findsOneWidget);

    await tap(tester, 'Sair da conta');
    expect(find.text('Bem-vindo de volta'), findsOneWidget);
  });

  testWidgets('login com e-mail não verificado volta para a verificação', (tester) async {
    // Fora do relógio simulado do teste, para o Future do cadastro concluir.
    await tester.runAsync(
      () => repository.register(name: 'Maria', email: 'maria@teste.com', password: 'senha123'),
    );
    await pumpApp(tester);

    await fill(tester, 'E-mail', 'maria@teste.com');
    await fill(tester, 'Senha', 'senha123');
    await tap(tester, 'Entrar', settle: false);

    expect(find.text('Verifique seu e-mail'), findsOneWidget);
    await tester.pump(VerifyEmailPage.verificationDelay);
    await tester.pumpAndSettle();
    expect(find.text('E-mail verificado!'), findsOneWidget);
  });

  testWidgets('cadastro rejeita senhas diferentes', (tester) async {
    await pumpApp(tester);
    await tap(tester, 'Cadastre-se');

    await fill(tester, 'Nome completo', 'Maria');
    await fill(tester, 'E-mail', 'maria@teste.com');
    await fill(tester, 'Senha', 'senha123');
    await fill(tester, 'Confirmar senha', 'senha999');
    await tap(tester, 'Criar conta');

    expect(find.text('As senhas não coincidem.'), findsOneWidget);
  });
}
