# Histórias de Usuário

### US01 - Cadastro
Como visitante, quero criar uma conta com nome, e-mail e senha, para poder usar o aplicativo.

- O sistema deve validar os campos antes de cadastrar.
- Não pode cadastrar um e-mail que já existe.
- Depois do cadastro, o usuário vai para a tela de verificação de e-mail.

### US02 - Verificação de e-mail
Como usuário cadastrado, quero verificar meu e-mail, para liberar meu acesso.

- A tela mostra o e-mail cadastrado e aguarda a verificação.
- Depois da verificação aparece a mensagem de sucesso e o botão para ir ao login.

### US03 - Login
Como usuário, quero entrar com meu e-mail e senha, para acessar minha conta.

- Se o e-mail ou a senha estiverem errados, aparece uma mensagem de erro.
- Se o e-mail não foi verificado, o usuário volta para a verificação.
- Se der certo, aparece a tela de início com "Login realizado com sucesso!".

### US04 - Recuperar senha
Como usuário, quero recuperar minha senha, caso eu esqueça.

- Na tela de login tem a opção "Esqueci minha senha".
- O usuário informa o e-mail e o sistema envia o link de redefinição.
- Se o e-mail não tiver conta cadastrada, aparece uma mensagem de erro.
- Ao abrir o link, o usuário cria a nova senha e confirma.
- Depois de salvar, aparece a mensagem de sucesso e o botão para ir ao login.

### US05 - Sair da conta
Como usuário, quero sair da minha conta.

- Na tela de início tem o botão "Sair da conta", que volta para o login.

### US06 - Continuar logado
Como usuário, quero continuar logado quando abrir o app de novo.

- Se o usuário não saiu da conta, o app abre direto na tela de início.
