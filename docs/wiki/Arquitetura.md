# Arquitetura

## Estrutura de pastas

```
lib/
├── main.dart                     # Carrega as contas salvas e roda o App
├── app/
│   ├── app.dart                  # MaterialApp, tema e injeção do AuthRepository
│   └── app_routes.dart           # Rotas nomeadas (/cadastro)
├── core/                         # Código reutilizável, sem regra de negócio
│   ├── theme/app_theme.dart      # Tema Material 3 claro/escuro
│   ├── utils/
│   │   ├── validators.dart       # Validação de nome, e-mail e senha
│   │   ├── password_strength.dart
│   │   └── snackbar.dart         # context.showSnack(...)
│   └── widgets/
│       ├── app_text_field.dart   # Campo padrão (com mostrar/ocultar senha)
│       └── loading_button.dart   # Botão com estado de carregamento
└── features/
    ├── auth/
    │   ├── domain/               # Modelos puros: AppUser, AuthException
    │   ├── data/
    │   │   ├── auth_repository.dart        # Interface (contrato no modelo do Firebase Auth)
    │   │   └── local_auth_repository.dart  # Implementação local (shared_preferences)
    │   └── presentation/
    │       ├── auth_gate.dart    # Login ↔ Início conforme a sessão
    │       ├── auth_scope.dart   # InheritedWidget que fornece o repositório
    │       ├── pages/            # login_page, register_page, verify_email_page
    │       └── widgets/          # auth_layout, password_strength_bar, forgot_password_dialog
    └── home/presentation/home_page.dart
test/
├── validators_test.dart
├── local_auth_repository_test.dart  # Cadastro, verificação, login e persistência
└── widget_test.dart                 # Fluxo completo nas telas
```

## Fluxo

```
main ──► LocalAuthRepository.create() ──► App ──► AuthScope ──► AuthGate
                                                                  │ authStateChanges()
                                                ┌─────────────────┴──────────────┐
                                           null ▼                                 ▼ AppUser
                                     LoginPage ──► RegisterPage ──► VerifyEmailPage  HomePage
                                         ▲                               │
                                         └──────── "Ir para o login" ◄───┘
```

## Decisões

| Decisão | Motivo |
|---|---|
| Organização por *feature* (`features/auth`, `features/home`) | Cada funcionalidade nova ganha sua pasta; escala melhor do que separar só por tipo de arquivo. |
| `AuthRepository` como interface, nos moldes do Firebase Auth | As telas não dependem de onde ficam as contas. Em uma etapa futura basta criar outra implementação (ex.: Firebase) sem mexer na interface. |
| Implementação local com `shared_preferences` | Atende à Etapa 0 sem depender de servidor; contas e sessão sobrevivem ao fechar o app. |
| Senha guardada como hash SHA-256 com *salt* (`crypto`) | Mesmo localmente, a senha nunca fica em texto no aparelho. |
| Verificação de e-mail simulada em 5 s | Reproduz a experiência de um site real (cadastro → confirmação → login) sem envio de e-mail. |
| `AuthGate` com `StreamBuilder` | A navegação entre Login e Início acontece sozinha quando a sessão muda, inclusive ao reabrir o app. |
| `InheritedWidget` em vez de pacote de estado | A Etapa 0 tem pouco estado global; evita dependências. Pode evoluir para Provider/Riverpod/Bloc depois. |
| Material 3 com `ColorScheme.fromSeed` | Tema consistente e acessível com uma única cor, e modo escuro automático. |
