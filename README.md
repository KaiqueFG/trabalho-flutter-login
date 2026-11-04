# App de Cadastro e Login (Flutter + Firebase)

Aplicativo Android em Flutter com cadastro e login de usuários por e-mail e senha, construído por etapas.

**Integrantes**
- Kaique ([@KaiqueFG](https://github.com/KaiqueFG))
- _[nome do(a) colega]_ ([@_usuario_](https://github.com/))

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

> ⚠️ **Rascunho — revisar e completar com as palavras de vocês antes de entregar.**

**Usamos IA?** Sim. Usamos o Claude (Anthropic), pelo aplicativo Claude Code.

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
- _[completar: por exemplo, como funciona a navegação entre telas, o que é um Form com validators, por que salvar o hash da senha, o que é estado (setState), etc.]_
