# App de Cadastro e Login (Flutter + Firebase)

Aplicativo Android em Flutter com cadastro e login de usuários por e-mail e senha, construído por etapas.

**Integrantes**
- Kaique Fantin Gaiarim — RA 60003260 ([@KaiqueFG](https://github.com/KaiqueFG))
- Gabriel Yoshio — RA 60006093

**Documentação complementar:** requisitos e histórias de usuário estão na [Wiki do repositório](https://github.com/KaiqueFG/trabalho-flutter-login/wiki).

## Como rodar

1. Instalar o Flutter SDK e o plugin Flutter no Android Studio
2. Abrir esta pasta no Android Studio e executar `flutter pub get`
3. Iniciar um emulador Android e clicar em **Run**

---

## Etapa 0 — Base do projeto, login e cadastro

### O que foi feito

- Criação do projeto Flutter, organizado por funcionalidade (`lib/features/auth` e `lib/features/home`)
- Tela de **login**, com mostrar/ocultar senha e opção "Esqueci minha senha"
- Tela de **cadastro**, com validação de nome, e-mail, senha e confirmação de senha, além de um indicador de força da senha
- Tela de **verificação de e-mail**: depois do cadastro, a verificação é simulada em 5 segundos e leva de volta ao login
- **Recuperação de senha**: envio do link (simulado), criação da nova senha e volta ao login
- Tela de **início** com a mensagem "Login realizado com sucesso!" e o botão de sair
- Autenticação baseada no modelo do **Firebase Auth** (e-mail e senha). Nesta etapa as contas ficam salvas no próprio aparelho (`shared_preferences`), com a senha protegida por hash SHA-256. A interface `AuthRepository` segue os métodos do Firebase Auth, para a troca pelo Firebase nas próximas etapas.
- Validações: e-mail único, senha com no mínimo 8 caracteres (letras e números), bloqueio de 30 segundos depois de 5 senhas erradas e nova senha diferente da atual
- Levantamento de requisitos e histórias de usuário na Wiki

### Prints

| Login | Cadastro | Verificando e-mail |
|:---:|:---:|:---:|
| <img src="docs/prints/01-login.png" width="220"> | <img src="docs/prints/02-cadastro.png" width="220"> | <img src="docs/prints/03-verificando.png" width="220"> |
| **E-mail verificado** | **Início** | **Esqueci minha senha** |
| <img src="docs/prints/04-verificado.png" width="220"> | <img src="docs/prints/05-inicio.png" width="220"> | <img src="docs/prints/06-esqueci-senha.png" width="220"> |
| **Link enviado** | **Nova senha** | **Senha alterada** |
| <img src="docs/prints/07-link-enviado.png" width="220"> | <img src="docs/prints/08-nova-senha.png" width="220"> | <img src="docs/prints/09-senha-alterada.png" width="220"> |

### Vídeo

_[link do vídeo não listado no YouTube]_

### Declaração de uso de IA

**Usamos IA?** Sim. Usamos o Claude (Anthropic), pelo aplicativo Claude Code. Esta declaração também foi redigida com ajuda da IA e revisada por nós.

**Para quê:**
- Configurar o ambiente: instalar o Flutter e o Git e resolver erros de compatibilidade entre o Gradle e o Java do Android Studio
- Gerar a estrutura do projeto e o código das telas de login, cadastro, verificação de e-mail, recuperação de senha e início
- Escrever as validações dos formulários e a lógica de autenticação local
- Escrever testes automatizados para conferir os fluxos
- Redigir os requisitos e as histórias de usuário da Wiki
- Criar o repositório no GitHub e publicar a Wiki

**O que a IA sugeriu:**
- Organizar o código por funcionalidade e separar a autenticação numa interface (`AuthRepository`) baseada nos métodos do Firebase Auth
- Integrar o Firebase de verdade desde o início
- Salvar a senha como hash SHA-256 com *salt*, em vez de texto puro
- Bloquear o login depois de várias senhas erradas e validar o nome só com letras

**O que nós decidimos ou alteramos:**
- Não conectar o Firebase real nesta etapa, já que o enunciado pedia o Firebase Auth apenas como referência. A verificação de e-mail e a recuperação de senha passaram a ser simuladas.
- Definimos o fluxo cadastro → verificação (5 segundos) → login → tela de sucesso
- Pedimos que a recuperação de senha mostrasse erro para e-mail não cadastrado e levasse a uma tela de nova senha
- Simplificamos a documentação da Wiki

**O que aprendemos:**
- **Ambiente:** o Flutter precisa estar no PATH para o Android Studio reconhecer o projeto, e a versão do Gradle precisa ser compatível com a versão do Java. O Android Studio novo traz o Java 25, que só funciona com o Gradle 9.
- **Telas e navegação:** cada tela é um widget. Com o `Navigator`, uma tela é aberta por cima da outra (`push`), e dá para voltar até a primeira (`popUntil`). O `AuthGate` decide sozinho entre o login e o início conforme o usuário está logado ou não.
- **Formulários:** um `Form` com `validator` em cada campo verifica os dados antes de enviar, e cada regra devolve uma mensagem de erro.
- **Estado:** `setState` atualiza a tela quando algo muda, como o botão de carregando ou a troca da etapa de verificação para a de sucesso.
- **Segurança:** salvar a senha em texto puro é perigoso. Guardamos só o hash (SHA-256 com *salt*) e, no login, comparamos o hash da senha digitada com o salvo.
- **Requisitos:** requisitos funcionais descrevem o que o sistema faz; os não funcionais descrevem como ele deve ser (plataforma, segurança, usabilidade).
- **Revisão:** nem tudo que a IA gera está certo de primeira. Testando o app como usuários, encontramos pontos que faltavam, como a recuperação de senha que não verificava se a conta existia, e pedimos as correções.
