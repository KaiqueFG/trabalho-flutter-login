# Histórias de Usuário

Formato: **Como** \<persona\>, **quero** \<ação\>, **para** \<benefício\>.
Critérios de aceite no formato *Dado / Quando / Então*. Estimativa em pontos (Fibonacci).

**Personas**
- **Visitante** — ainda não tem conta.
- **Usuário** — já tem conta (logado ou não).

## Resumo do backlog

| ID | História | Requisitos | Prioridade | Pontos | Etapa |
|---|---|---|---|---|---|
| US01 | Criar conta com e-mail e senha | RF01, RF10, RN01–RN05 | Alta | 5 | 0 ✅ |
| US02 | Verificar meu e-mail | RF02, RF03, RN07 | Alta | 3 | 0 ✅ |
| US03 | Entrar com e-mail e senha | RF04, RF05, RF10, RN06 | Alta | 3 | 0 ✅ |
| US04 | Ver a confirmação de login | RF06 | Alta | 1 | 0 ✅ |
| US05 | Ver erros claros ao falhar | RF11, RNF03 | Alta | 2 | 0 ✅ |
| US06 | Continuar conectado | RF07, RNF04 | Alta | 2 | 0 ✅ |
| US07 | Sair da conta | RF08 | Alta | 1 | 0 ✅ |
| US08 | Recuperar senha esquecida | RF09, RNF03 | Média | 3 | 0 ✅ |
| US09 | Receber e-mails reais | RF12 | Média | 5 | Futuro |
| US10 | Editar meu perfil | RF13 | Baixa | 5 | Futuro |
| US11 | Excluir minha conta | RF14 | Baixa | 3 | Futuro |

---

## US01 — Criar conta

**Como** visitante, **quero** criar uma conta com nome, e-mail e senha, **para** acessar o aplicativo.

**Critérios de aceite**
1. **Dado** que estou na tela de Login, **quando** toco em "Cadastre-se", **então** vejo a tela "Criar conta" com os campos Nome completo, E-mail, Senha e Confirmar senha.
2. **Dado** que deixei algum campo vazio ou inválido, **quando** toco em "Criar conta", **então** cada campo com problema mostra sua mensagem e nada é enviado.
3. **Dado** que digitei uma senha com menos de 8 caracteres ou sem letras e números, **então** vejo "A senha deve ter pelo menos 8 caracteres." ou "Use letras e números.".
4. **Dado** que a confirmação é diferente da senha, **então** vejo "As senhas não coincidem.".
5. **Dado** que estou digitando a senha, **então** vejo um indicador de força (Fraca / Média / Forte).
6. **Dado** que os dados são válidos, **quando** toco em "Criar conta", **então** a conta é criada com o e-mail não verificado e sou levado à tela de verificação de e-mail.
7. **Dado** que o e-mail já está em uso, **então** vejo "Já existe uma conta com este e-mail." e continuo na tela de cadastro.

## US02 — Verificar e-mail

**Como** usuário recém-cadastrado, **quero** confirmar meu e-mail, **para** liberar o acesso à minha conta.

**Critérios de aceite**
1. **Dado** que concluí o cadastro, **então** vejo "Verifique seu e-mail", o endereço cadastrado e a indicação "Aguardando a confirmação do seu e-mail...".
2. **Dado** que estou na verificação, **quando** se passam 5 segundos, **então** vejo "E-mail verificado!" e "Seu e-mail foi verificado com sucesso".
3. **Dado** que meu e-mail foi verificado, **quando** toco em "Ir para o login", **então** volto para a tela de Login.
4. **Dado** que a verificação está em andamento, **quando** toco em voltar, **então** continuo na tela até a verificação terminar.

## US03 — Entrar com e-mail e senha

**Como** usuário, **quero** entrar com meu e-mail e senha, **para** acessar minha conta.

**Critérios de aceite**
1. **Dado** que abro o app sem estar logado, **então** vejo a tela de Login com E-mail, Senha, "Esqueci minha senha", "Entrar" e "Cadastre-se".
2. **Dado** que os campos estão vazios, **quando** toco em "Entrar", **então** vejo "Informe seu e-mail." e "Informe sua senha.".
3. **Dado** credenciais válidas de uma conta verificada, **quando** toco em "Entrar", **então** vejo o carregamento e depois a tela de Início.
4. **Dado** uma conta com e-mail ainda não verificado, **quando** toco em "Entrar", **então** vejo "Confirme seu e-mail antes de entrar." e sou levado à verificação.
5. **Dado** que estou digitando a senha, **quando** toco no ícone de olho, **então** a senha é mostrada/ocultada.

## US04 — Confirmação de login

**Como** usuário, **quero** ver claramente que entrei, **para** ter certeza de que o login funcionou.

**Critérios de aceite**
1. **Dado** que entrei, **então** a tela de Início mostra "Login realizado com sucesso!", "Olá, \<primeiro nome\>!", meu e-mail e o selo "E-mail verificado".

## US05 — Mensagens de erro claras

**Como** usuário, **quero** entender por que a ação falhou, **para** saber como corrigir.

**Critérios de aceite**
1. **Dado** e-mail ou senha incorretos, **então** vejo "E-mail ou senha incorretos." — sem indicar qual dos dois está errado.
2. Todas as mensagens aparecem em português, em uma *snackbar* de erro, sem travar a tela.

## US06 — Continuar conectado

**Como** usuário, **quero** continuar logado ao fechar e reabrir o app, **para** não precisar digitar a senha toda vez.

**Critérios de aceite**
1. **Dado** que entrei e fechei o app, **quando** abro novamente, **então** vou direto para a tela de Início.
2. **Dado** que saí da conta, **quando** abro o app, **então** vejo a tela de Login e minha conta continua cadastrada.

## US07 — Sair da conta

**Como** usuário, **quero** sair da minha conta, **para** proteger meu acesso em um aparelho compartilhado.

**Critérios de aceite**
1. **Dado** que estou na tela de Início, **quando** toco em "Sair da conta" (ou no ícone da barra superior), **então** volto para a tela de Login.

## US08 — Recuperar senha

**Como** usuário, **quero** solicitar a redefinição da minha senha, **para** recuperar o acesso caso a esqueça.

**Critérios de aceite**
1. **Dado** que estou no Login, **quando** toco em "Esqueci minha senha", **então** abre um diálogo com o campo E-mail, já preenchido com o que digitei no Login.
2. **Dado** um e-mail inválido, **então** vejo "E-mail inválido.".
3. **Dado** um e-mail válido, **quando** toco em "Enviar link", **então** vejo "Se houver uma conta com este e-mail, você receberá o link de redefinição." — a mesma mensagem existindo ou não a conta.

---

## Backlog futuro

- **US09 — E-mails reais:** como usuário, quero receber de verdade os e-mails de verificação e redefinição de senha (integração com o Firebase Auth).
- **US10 — Editar perfil:** como usuário, quero alterar nome, e-mail e senha.
- **US11 — Excluir conta:** como usuário, quero excluir minha conta após confirmar minha senha.

## Definição de Pronto (DoD)

- Critérios de aceite atendidos e verificados no emulador Android.
- `flutter analyze` sem avisos e `flutter test` passando.
- Textos em português e telas funcionando em tema claro e escuro.
- Wiki atualizada.
