# Requisitos

## Requisitos funcionais

- **RF01** - O usuário deve conseguir se cadastrar com nome, e-mail e senha.
- **RF02** - Após o cadastro, o sistema deve verificar o e-mail do usuário.
- **RF03** - O usuário deve conseguir fazer login com e-mail e senha.
- **RF04** - O sistema só deve permitir login de usuários com e-mail verificado.
- **RF05** - O usuário deve conseguir pedir a recuperação de senha.
- **RF06** - O usuário deve conseguir sair da conta.
- **RF07** - O sistema deve mostrar mensagens de erro quando os dados estiverem errados.

## Requisitos não funcionais

- **RNF01** - O aplicativo deve ser feito em Flutter para Android.
- **RNF02** - A autenticação deve seguir o modelo do Firebase Auth (e-mail e senha).
- **RNF03** - A senha não deve ser salva em texto puro.
- **RNF04** - O usuário deve continuar logado ao fechar e abrir o app.

## Regras

- O e-mail deve ser válido e não pode estar cadastrado.
- A senha deve ter no mínimo 8 caracteres, com letras e números.
- A confirmação de senha deve ser igual à senha.
