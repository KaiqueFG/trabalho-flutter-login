# Etapa 0 — Configuração do ambiente (Android Studio)

Passo a passo na ordem correta, com os erros mais comuns e como corrigi-los.
Ambiente-alvo: **Windows 11 + Android Studio + emulador Android**.

## Checklist rápido

- [ ] 1. Git e Flutter SDK instalados e no `PATH`
- [ ] 2. Android Studio com plugin Flutter, SDK e emulador
- [ ] 3. `flutter doctor` sem erros na parte Android
- [ ] 4. Projeto aberto no Android Studio e *Pub get* executado
- [ ] 5. App rodando no emulador
- [ ] 6. Testes e análise passando
- [ ] 7. Código e wiki no GitHub

---

## 1. Instalar o Git e o Flutter SDK

1. Instale o Git: <https://git-scm.com/download/win> (ou `winget install Git.Git`).
2. Baixe o Flutter **stable** para Windows em <https://docs.flutter.dev/get-started/install/windows/mobile>.
3. Extraia em um caminho **sem espaços e sem acentos**, fora de `Program Files`, por exemplo `C:\dev\flutter`.
4. Adicione `C:\dev\flutter\bin` à variável de ambiente **Path** do usuário
   (Iniciar → "Editar as variáveis de ambiente para sua conta" → Path → Novo).
5. **Feche e reabra** o terminal e o Android Studio, e confira:

```bash
flutter --version
```

> ⚠️ **Erro comum:** `flutter não é reconhecido como nome de cmdlet` → o `bin` não está no Path ou o terminal não foi reaberto.
> ⚠️ **Erro comum:** SDK em caminho com espaço/acentos (ex.: `C:\Users\João\Meus Projetos\flutter`) quebra o Gradle. Use `C:\dev\flutter`.

## 2. Preparar o Android Studio

1. **File → Settings → Plugins → Marketplace**: instale **Flutter** (instala o **Dart** junto) e reinicie.
2. **File → Settings → Languages & Frameworks → Flutter**: em *Flutter SDK path* informe `C:\dev\flutter`.
3. **Tools → SDK Manager → SDK Tools**: marque **Android SDK Command-line Tools (latest)**, **Android SDK Build-Tools**, **Android Emulator** e **Android SDK Platform-Tools**.
4. **Device Manager → Create Virtual Device**: escolha um Pixel com imagem de sistema recente.
5. Aceite as licenças:

```bash
flutter doctor --android-licenses
```

## 3. Validar o ambiente

```bash
flutter doctor -v
```

| Mensagem | Correção |
|---|---|
| `cmdline-tools component is missing` | Instale *Android SDK Command-line Tools* no SDK Manager (passo 2.3). |
| `Android license status unknown` | `flutter doctor --android-licenses` e aceite tudo com `y`. |
| `Unable to locate Android SDK` | `flutter config --android-sdk "%LOCALAPPDATA%\Android\Sdk"` |
| Emulador não inicia / muito lento | Ative a **Plataforma de Máquina Virtual** e o **Hypervisor do Windows** em "Ativar ou desativar recursos do Windows" e habilite a virtualização (VT-x/AMD-V) na BIOS. |
| `Visual Studio not installed` | Só é necessário para apps Windows desktop. Pode ignorar. |

## 4. Abrir o projeto

A pasta `android/` foi gerada com o Flutter 3.47 (Gradle 9.3.1, Android Gradle Plugin 9.1.0, Kotlin 2.4.0, Java 17+).

1. **File → Open** → selecione a pasta do projeto (a que contém o `pubspec.yaml`).
2. Quando aparecer a faixa *"Pub get has not been run"*, clique em **Pub get**.

> ⚠️ **Erro comum:** `flutter.sdk not set in local.properties` → o Pub get ainda não foi executado. Rode `flutter pub get` na raiz do projeto.
> ⚠️ **Erro comum:** `The Java version used for the build is 25, which is incompatible with Gradle 8.x` → o Android Studio 2026 traz o Java 25, que exige Gradle 9.1 ou mais novo. Este projeto já usa o Gradle 9.3.1.
> ⚠️ **Erro comum:** abrir só a pasta `android/` → abra a **raiz** do projeto.

## 5. Rodar o app

1. Inicie o emulador no **Device Manager** e espere o Android ligar por completo.
2. Na barra superior, confira se o dispositivo selecionado é o emulador e se a configuração é `main.dart`.
3. Clique em **Run ▶**.

Ou pelo terminal, que liga o emulador `Pixel_7` e roda o app:

```bash
powershell -ExecutionPolicy Bypass -File scripts\run.ps1
```

> ⚠️ **Erro comum:** abriu outro app no emulador → havia outra janela do Android Studio com outro projeto. Feche-a e rode a partir da janela deste projeto.

### Como testar o fluxo

1. **Cadastre-se** com nome, e-mail e senha (mínimo de 8 caracteres, com letras e números).
2. Na tela **Verifique seu e-mail**, aguarde 5 segundos até aparecer **"E-mail verificado!"**.
3. Toque em **Ir para o login** e entre com o mesmo e-mail e senha.
4. A tela de Início mostra **"Login realizado com sucesso!"**.

As contas ficam salvas no aparelho. Para apagá-las, desinstale o app ou limpe os dados em *Configurações → Apps*.

## 6. Qualidade

```bash
flutter analyze
```

```bash
flutter test
```

## 7. Versionar e publicar a wiki

```bash
git init
```

```bash
git add .
```

```bash
git commit -m "Etapa 0: base do projeto, login, cadastro e wiki"
```

Crie o repositório no GitHub, conecte com `git remote add origin <url>` e faça `git push -u origin main`.
Para a wiki, veja a seção "Como publicar esta wiki" na [página inicial](Home).

---

## Correções em relação ao roteiro comum

| Problema no roteiro usual | Correção aplicada neste projeto |
|---|---|
| Gradle 8.x com o Java 25 do Android Studio 2026 | Pasta `android/` gerada com Gradle 9.3.1 / AGP 9.1.0. |
| Usar `context` depois de `await` sem checar `mounted` | Todas as telas verificam `mounted` após chamadas assíncronas. |
| Navegar manualmente para a tela inicial após o login | `AuthGate` observa a sessão e troca a tela sozinho (também mantém a sessão ao reabrir). |
| Cadastro já deixar o usuário logado sem confirmar o e-mail | Cadastro leva à verificação; o login exige e-mail verificado. |
| Guardar a senha em texto no aparelho | Guarda apenas o hash SHA-256 com *salt*. |
| `TextEditingController` sem `dispose` | Todos são liberados no `dispose()`. |
| Mensagem de recuperação que revela se o e-mail existe | Mensagem neutra. |
