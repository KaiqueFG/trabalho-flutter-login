# Auth Base — Wiki

Aplicativo Flutter (Android) com autenticação por **e-mail e senha**, construído com base no modelo do **Firebase Authentication**.
Esta é a base do projeto: estrutura de pastas, tema visual, telas de **Login**, **Cadastro**, **Verificação de e-mail** e **Início**.

Nesta etapa a autenticação é **local**: as contas ficam salvas no próprio aparelho e a verificação de e-mail é simulada.
As telas e o contrato de autenticação (`AuthRepository`) seguem os métodos do Firebase Auth, para que a troca por um backend real seja feita em etapa futura sem alterar a interface.

## Páginas

| Página | Conteúdo |
|---|---|
| [Etapa 0 — Configuração do ambiente](Etapa-0) | Passo a passo no Android Studio, do zero até o app rodando |
| [Requisitos](Requisitos) | Requisitos funcionais, não funcionais e regras de negócio |
| [Histórias de Usuário](Historias-de-Usuario) | Histórias com critérios de aceite e prioridade |
| [Arquitetura](Arquitetura) | Organização do código e decisões técnicas |

## Fluxo do app

```
Login ──"Cadastre-se"──► Cadastro ──► Verificação de e-mail (5 s) ──► "E-mail verificado!"
  ▲                                                                         │
  └──────────────────────────── "Ir para o login" ◄─────────────────────────┘
Login (e-mail verificado) ──► Início: "Login realizado com sucesso!" ──"Sair"──► Login
```

## Status da Etapa 0

- [x] Projeto Flutter criado e organizado por *features*
- [x] Tema Material 3 (claro/escuro)
- [x] Tela de Login
- [x] Tela de Cadastro
- [x] Tela de Verificação de e-mail (simulada)
- [x] Tela de Início com confirmação de login
- [x] Recuperação de senha (diálogo)
- [x] Contas salvas no aparelho, com senha protegida por hash
- [x] Testes unitários e de widget
- [x] Requisitos e histórias de usuário documentados

## Como publicar esta wiki no GitHub

A wiki do GitHub é um repositório separado (`<repo>.wiki.git`). Para publicar estes arquivos:

```bash
git clone https://github.com/<usuario>/<repo>.wiki.git
```

Copie os arquivos de `docs/wiki/` para a pasta clonada e faça commit/push. O nome do arquivo vira o nome da página
(`Historias-de-Usuario.md` → página "Historias de Usuario"); `_Sidebar.md` vira o menu lateral.
