# Requisitos

Levantamento feito a partir do escopo inicial — *"base do projeto em Flutter com telas de login e cadastro, usando
como referência os modelos do Firebase Auth na autenticação por e-mail"* — e das capacidades do provedor **E-mail/Senha**
do Firebase Authentication (`createUserWithEmailAndPassword`, `signInWithEmailAndPassword`, `sendEmailVerification`,
`sendPasswordResetEmail`, `signOut`, `authStateChanges`).

Nesta etapa a autenticação é **local** (contas salvas no aparelho) e a verificação de e-mail é **simulada**.

> Os itens marcados como **Futuro** não fazem parte da Etapa 0, mas foram identificados e ficam registrados no backlog.

## Requisitos funcionais (RF)

| ID | Requisito | Referência Firebase Auth | Prioridade | Status |
|---|---|---|---|---|
| RF01 | O sistema deve permitir que o usuário crie uma conta informando nome, e-mail, senha e confirmação de senha. | `createUserWithEmailAndPassword` | Alta | Feito |
| RF02 | Após o cadastro, o sistema deve exibir a tela de verificação de e-mail e, após 5 segundos, confirmar o e-mail de forma simulada. | `sendEmailVerification` | Alta | Feito |
| RF03 | Após a verificação, o sistema deve informar "Seu e-mail foi verificado com sucesso" e oferecer o botão "Ir para o login". | — | Alta | Feito |
| RF04 | O sistema deve permitir que o usuário entre com e-mail e senha cadastrados. | `signInWithEmailAndPassword` | Alta | Feito |
| RF05 | O sistema deve impedir o login de contas com e-mail não verificado e levar o usuário para a verificação. | `User.emailVerified` | Média | Feito |
| RF06 | Após o login, o sistema deve exibir a tela de início com a mensagem "Login realizado com sucesso!" e os dados do usuário. | `User.displayName/email` | Alta | Feito |
| RF07 | O sistema deve manter o usuário conectado ao reabrir o app até que ele saia. | Persistência de sessão | Alta | Feito |
| RF08 | O sistema deve permitir que o usuário saia da conta (logout). | `signOut` | Alta | Feito |
| RF09 | O sistema deve permitir solicitar a redefinição de senha por e-mail. | `sendPasswordResetEmail` | Média | Feito (simulado) |
| RF10 | O sistema deve validar os campos dos formulários antes de enviar. | — | Alta | Feito |
| RF11 | O sistema deve exibir mensagens de erro claras, em português. | Códigos de erro do Firebase Auth | Alta | Feito |
| RF12 | O sistema deve enviar e-mails reais de verificação e redefinição de senha (backend real). | Firebase Auth | Média | Futuro |
| RF13 | O sistema deve permitir alterar nome, e-mail e senha no perfil. | `updateProfile`, `updatePassword` | Baixa | Futuro |
| RF14 | O sistema deve permitir excluir a própria conta. | `delete` | Baixa | Futuro |

## Requisitos não funcionais (RNF)

| ID | Requisito |
|---|---|
| RNF01 | **Plataforma:** Android 7.0 ou superior (minSdk 24), desenvolvido no Android Studio com Flutter estável e Dart 3. |
| RNF02 | **Segurança:** a senha nunca é armazenada em texto; guarda-se apenas o hash SHA-256 da senha com um *salt* aleatório por conta. |
| RNF03 | **Segurança:** mensagens de login e de recuperação de senha não revelam se um e-mail está cadastrado. |
| RNF04 | **Persistência:** contas e sessão ficam salvas no aparelho (`shared_preferences`) e continuam disponíveis ao reabrir o app. |
| RNF05 | **Usabilidade:** interface em Material 3, com tema claro e escuro conforme o sistema. |
| RNF06 | **Usabilidade:** mostrar/ocultar senha, indicador de força da senha e preenchimento automático (autofill). |
| RNF07 | **Feedback:** toda ação mostra estado de carregamento e bloqueia envios duplicados. |
| RNF08 | **Responsividade:** formulários com largura máxima de 440 px e rolagem, funcionando em celulares pequenos, tablets e paisagem. |
| RNF09 | **Acessibilidade:** rótulos em todos os campos e *tooltips* em botões de ícone. |
| RNF10 | **Manutenibilidade:** código organizado por *feature*, com a autenticação atrás de uma interface (`AuthRepository`) baseada no Firebase Auth. |
| RNF11 | **Qualidade:** `flutter analyze` sem avisos e testes automatizados para validações, repositório e fluxos principais. |

## Regras de negócio (RN)

| ID | Regra |
|---|---|
| RN01 | O e-mail deve ter formato válido (`nome@dominio.ext`) e é único por conta, sem diferenciar maiúsculas e minúsculas. |
| RN02 | A senha do cadastro deve ter **no mínimo 8 caracteres**, contendo **letras e números**. |
| RN03 | A confirmação de senha deve ser idêntica à senha. |
| RN04 | O nome deve ter ao menos 2 caracteres. |
| RN05 | Toda conta nasce com o e-mail **não verificado** e o cadastro **não** inicia sessão. |
| RN06 | Só é possível entrar com o e-mail **verificado**. |
| RN07 | A verificação simulada leva **5 segundos**; durante esse tempo o usuário não sai da tela por engano. |

## Mensagens de erro

| Código | Mensagem exibida |
|---|---|
| `invalidEmail` | O e-mail informado é inválido. |
| `invalidCredentials` | E-mail ou senha incorretos. |
| `emailAlreadyInUse` | Já existe uma conta com este e-mail. |
| `weakPassword` | A senha é muito fraca. |
| `emailNotVerified` | Confirme seu e-mail antes de entrar. |
| `unknown` | Algo deu errado. Tente novamente. |
