# Auth Base (Flutter)

Base de projeto Flutter para Android com **Login**, **Cadastro** e **Verificação de e-mail**, seguindo o modelo de autenticação por e-mail e senha do **Firebase Authentication**.

## Funcionalidades

- Cadastro com nome, e-mail, senha, confirmação e indicador de força da senha
- Verificação de e-mail simulada (5 segundos) com redirecionamento para o login
- Login com mostrar/ocultar senha e preenchimento automático
- Tela de início com confirmação de login
- Recuperação de senha
- Contas e sessão salvas no aparelho (senha protegida por hash SHA-256 com salt)
- Material 3 com tema claro/escuro

## Começando

1. Instale o Flutter SDK e o plugin Flutter no Android Studio.
2. No Android Studio: **File → Open** → esta pasta → clique em **Pub get**.
3. Escolha o emulador e clique em **Run ▶**.

Ou pelo terminal:

```bash
powershell -ExecutionPolicy Bypass -File scripts\run.ps1
```

O passo a passo completo está em [docs/wiki/Etapa-0.md](docs/wiki/Etapa-0.md).

## Documentação (wiki)

- [Etapa 0 — Ambiente](docs/wiki/Etapa-0.md)
- [Requisitos](docs/wiki/Requisitos.md)
- [Histórias de Usuário](docs/wiki/Historias-de-Usuario.md)
- [Arquitetura](docs/wiki/Arquitetura.md)
