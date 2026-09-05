<div align="center">

# 🧘 Slow Down — MVP

*Guia de Execução e Arquitetura do Produto*

<img src="https://img.shields.io/badge/Frontend-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Backend-Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js">
<img src="https://img.shields.io/badge/Banco-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL">
<img src="https://img.shields.io/badge/Auth-Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">

</div>

Guia único do MVP: como o app funciona por baixo dos panos e o passo a passo para colocar tudo rodando na sua máquina. Os READMEs específicos de [`backend/`](backend/README.md) e [`frontend/`](frontend/README.md) continuam existindo para detalhes de cada parte; este arquivo é o ponto de partida.

## Sumário

- [Visão geral](#visão-geral)
- [Como as peças se conectam](#como-as-peças-se-conectam)
- [O que já funciona de verdade vs. o que ainda é simulado](#o-que-já-funciona-de-verdade-vs-o-que-ainda-é-simulado)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Pré-requisitos](#pré-requisitos)
- [Passo a passo — Backend](#passo-a-passo--backend)
- [Passo a passo — Frontend](#passo-a-passo--frontend)
- [Rodando os testes automatizados](#rodando-os-testes-automatizados)
- [Práticas de Engenharia de Software aplicadas](#práticas-de-engenharia-de-software-aplicadas)
- [Segurança: leia antes de subir para o GitHub](#segurança-leia-antes-de-subir-para-o-github)
- [Erros comuns](#erros-comuns)
- [O que falta fazer](#o-que-falta-fazer)

## Visão geral

O **Slow Down** é um app de apoio ao cuidado contra o burnout: registro de humor, meditação, um pet virtual que evolui com o autocuidado do usuário, monitoramento de frequência cardíaca e conteúdo em áudio.

O projeto é dividido em duas partes que rodam separadamente e conversam por HTTP:

| Parte | Tecnologia | Onde fica |
| --- | --- | --- |
| **Frontend** | Flutter (Android/iOS/Web) | `frontend/` |
| **Backend** | Node.js + Express + MySQL | `backend/` |
| **Autenticação** | Firebase Authentication (e-mail/senha + Google) | usada pelos dois lados |

## Como as peças se conectam

```
┌─────────────┐        Firebase Auth         ┌──────────────────┐
│   Flutter   │ ────────────────────────────▶ │  Firebase (login)│
│  (frontend) │ ◀──────────────────────────── │  e-mail ou Google│
└──────┬──────┘        token JWT              └──────────────────┘
       │
       │ POST /auth/sync  (Authorization: Bearer <token>)
       ▼
┌─────────────┐                               ┌──────────────────┐
│   Node.js   │ ────────────────────────────▶ │      MySQL       │
│  (backend)  │        salva/lê o usuário      │  tabela `users`  │
└─────────────┘                               └──────────────────┘
```

Passo a passo do login (é o fluxo mais importante para entender o projeto):

1. O usuário digita e-mail/senha (ou toca em "Continuar com Google") na tela de login do Flutter.
2. O Flutter autentica diretamente com o **Firebase** — é o Firebase que valida a senha, não o backend Node.js.
3. O Firebase devolve um **token JWT**. O app guarda esse token localmente (`SessionManager`, via `shared_preferences`).
4. O app faz `POST /auth/sync` para o backend Node.js, enviando o token no cabeçalho `Authorization: Bearer <token>`.
5. O backend valida o token com o **Firebase Admin SDK** e verifica se aquele usuário já existe na tabela `users` do MySQL. Se não existir, cria; se existir, retorna os dados salvos (nome, plano, etc.).
6. O app salva o `id` retornado pelo MySQL e passa a usá-lo como identificador interno do usuário.

Ou seja: **o Firebase cuida de "quem é o usuário"; o MySQL guarda "o que sabemos sobre esse usuário" dentro do app** (plano, dados de perfil, etc.).

Todas as chamadas ao backend passam por um único lugar no código Flutter — `ApiConfig.baseUrl` (`frontend/lib/src/services/api_config.dart`) — então trocar o endereço do backend (por exemplo, ao publicar em produção) é uma alteração em um arquivo só.

## O que já funciona de verdade vs. o que ainda é simulado

O MVP tem bastante coisa clicável, mas nem tudo está conectado a um backend real. Isso é intencional (permite validar a experiência antes de construir a infraestrutura completa), mas é importante saber a diferença:

**Funciona de ponta a ponta (frontend ↔ backend/Firebase real):**
- Cadastro e login por e-mail/senha (Firebase Auth)
- Login com Google
- Sincronização do usuário com o MySQL (`/auth/sync`)
- Recuperação de senha por e-mail (Firebase Auth)
- Registro de humor diário, histórico e termômetro emocional (persistidos localmente no dispositivo via `shared_preferences` — ainda não vão para o MySQL, ver seção seguinte)

**Simulado / com dados de exemplo (funciona na tela, mas não é real ainda):**
- Verificação de código por e-mail (OTP): aceita sempre `123456`, não existe envio de e-mail nem tabela no banco
- Chatbot de apoio emocional: respostas geradas por regras locais, sem IA de verdade
- Integração com Apple Health / Google Health Connect: precisa de configuração nativa adicional (ver comentários em `frontend/lib/screens/health_service.dart`)
- Sleepcasts/áudio de meditação: player simulado, sem arquivos de áudio reais
- Assinatura Premium, notificações push, modo offline com downloads reais: guardam apenas o *estado* localmente, sem a integração real por trás

Cada uma dessas telas tem um comentário no topo do arquivo explicando exatamente o que falta para se tornar real — é o primeiro lugar para olhar antes de implementar a versão completa de qualquer uma delas.

## Estrutura de pastas

```
4-MVP/
├── mvp/
│   ├── backend/          # API Node.js + Express
│   │   ├── src/
│   │   │   ├── config/       # Conexão MySQL e inicialização do Firebase Admin
│   │   │   ├── controllers/  # Lógica de cada rota
│   │   │   ├── middlewares/  # Validação do token Firebase
│   │   │   ├── models/       # Acesso ao banco (camada Model do MVC)
│   │   │   ├── routes/       # Definição das rotas HTTP
│   │   │   └── server.js     # Ponto de entrada
│   │   ├── database.sql      # Script de criação do banco
│   │   └── .env.example      # Modelo das variáveis de ambiente
│   └── frontend/         # App Flutter
│       ├── lib/
│       │   ├── screens/        # Uma tela por arquivo
│       │   └── src/
│       │       ├── providers/    # Estado global (Riverpod)
│       │       ├── repositories/ # Chamadas HTTP organizadas por domínio
│       │       ├── services/     # Sessão, config de API, autenticação
│       │       └── utils/        # Validadores (regras de negócio puras, testáveis)
│       └── test/            # Testes automatizados (unitários e de widget)
├── docs/                 # Documentação complementar
└── prints/               # Capturas de tela do app
```

## Pré-requisitos

Instale antes de começar:

- **Flutter SDK** (canal stable) — [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- **Node.js** 18 ou superior e **npm**
- **MySQL** 8 (local ou em nuvem)
- Uma conta no **Firebase** com um projeto criado ([console.firebase.google.com](https://console.firebase.google.com))
- Android Studio ou Xcode, se for testar em emulador/dispositivo

## Passo a passo — Backend

1. **Instale as dependências**
   ```bash
   cd 4-MVP/mvp/backend
   npm install
   ```

2. **Crie o banco de dados**

   Rode o script `database.sql` no seu MySQL (via linha de comando, MySQL Workbench, DBeaver, etc.). Ele cria o banco `slowdown_db` e a tabela `users`.

3. **Configure as variáveis de ambiente**

   Copie o modelo e preencha com os dados do seu MySQL local:
   ```bash
   cp .env.example .env
   ```
   Edite `.env` com `DB_USER`, `DB_PASSWORD` e `DB_NAME` corretos para o seu ambiente.

4. **Baixe a credencial do Firebase Admin SDK**

   No [Firebase Console](https://console.firebase.google.com) → Configurações do projeto → Contas de serviço → **Gerar nova chave privada**. Isso baixa um arquivo `.json`.

   Salve esse arquivo **exatamente** como `firebase-service-account.json` dentro de `backend/` (na raiz da pasta backend, não em nenhuma subpasta). O nome importa: é o que está gitignorado, e é o que `FIREBASE_SERVICE_ACCOUNT_PATH` no `.env` espera encontrar.

   > Esse arquivo é uma credencial sensível — nunca deve ser commitado. Veja a seção [Segurança](#segurança-leia-antes-de-subir-para-o-github) abaixo.

5. **Suba o servidor**
   ```bash
   npm run dev
   ```
   Se tudo estiver certo, o terminal mostra a porta em que o servidor está rodando e a confirmação de conexão com o MySQL.

## Passo a passo — Frontend

1. **Instale as dependências**
   ```bash
   cd 4-MVP/mvp/frontend
   flutter pub get
   ```

2. **Configure o Firebase no app**

   O projeto já usa o pacote `firebase_core`. Se for usar seu próprio projeto Firebase (em vez do que já está configurado), rode a CLI do FlutterFire para regenerar `lib/firebase_options.dart`:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Isso também baixa o `google-services.json` (Android) e o `GoogleService-Info.plist` (iOS) automaticamente.

3. **Aponte o app para o backend**

   Em `lib/src/services/api_config.dart`, ajuste `baseUrl` conforme onde você for testar:

   | Ambiente | `baseUrl` |
   | --- | --- |
   | Emulador Android | `http://10.0.2.2:3000` (já é o padrão) |
   | Chrome / desktop | `http://localhost:3000` |
   | Celular físico na mesma rede | `http://<IP-da-sua-máquina>:3000` |

4. **Rode o app**
   ```bash
   flutter run
   ```
   Com o backend já rodando (passo anterior), o cadastro e o login devem funcionar de ponta a ponta.

## Rodando os testes automatizados

```bash
cd 4-MVP/mvp/frontend
flutter test
```

Os testes cobrem os validadores de regras de negócio (e-mail, senha, BPM, registro emocional) e o comportamento de algumas telas (login, cadastro, monitoramento, registro emocional). Rodar um arquivo específico:
```bash
flutter test test/us16_validador_auth_test.dart
```

## Práticas de Engenharia de Software aplicadas

Como o MVP materializa, em código, o que foi especificado nas fases anteriores do projeto (TP1 a TP3).

### Padrão arquitetural MVC

A separação definida em [`2-projeto-e-arquitetura/1-padroes-arquiteturais.md`](../../2-projeto-e-arquitetura/1-padroes-arquiteturais.md) é observável na estrutura do backend:

| Camada | Onde está no código | Responsabilidade |
| :--- | :--- | :--- |
| **Model** | `backend/src/models/` | Único ponto que executa SQL e acessa o MySQL |
| **Controller** | `backend/src/controllers/` | Recebe a requisição, aplica regras e chama o Model |
| **View** | `frontend/lib/screens/` | Interface Flutter, sem regra de negócio nem SQL |

> Controllers não executam SQL diretamente: toda consulta passa pelo Model. Isso mantém o baixo acoplamento previsto na documentação e permite trocar o banco sem reescrever os controllers.

### Rastreabilidade C4 (Nível 3 → Código)

O diagrama de componentes do TP2 se traduz diretamente em arquivos:

| Componente (C4 Nível 3) | Implementação |
| :--- | :--- |
| Controlador de Login | `backend/src/controllers/authController.js` |
| Componente de Segurança | `backend/src/middlewares/authMiddleware.js` (valida o token do Firebase) |
| Acesso a Dados | `backend/src/models/userModel.js` |
| Configuração de Integração | `frontend/lib/src/services/api_config.dart` |

O mapeamento completo entre Histórias de Usuário e telas está em [`docs/rastreabilidade.md`](../docs/rastreabilidade.md).

### Estratégia de testes

Os testes seguem a pirâmide de testes, com base larga de testes de unidade e uma camada menor de testes de integração de interface:

| Nível | Arquivos | O que verifica |
| :--- | :--- | :--- |
| **Unidade** (base) | `us04_validador_bpm_test.dart`, `us06_validador_registro_emocional_test.dart`, `us16_validador_auth_test.dart` | Regras de negócio puras, isoladas da interface |
| **Integração/Widget** | `us04_monitor_screen_widget_test.dart`, `us06_emotional_record_screen_widget_test.dart`, `us16_register_screen_widget_test.dart` | Comunicação entre validadores e telas |

As regras de negócio foram isoladas em `frontend/lib/src/utils/` justamente para serem testáveis sem depender da interface gráfica — decisão que viabiliza a base da pirâmide.

Os casos de teste derivam da técnica de **Particionamento em Classes de Equivalência** (teste funcional / caixa preta), documentada em [`3-casos-de-teste/classes-equivalencia.md`](../../3-casos-de-teste/classes-equivalencia.md), com classes válidas e inválidas testadas individualmente para evitar mascaramento mútuo de defeitos.

> **Importante:** as mensagens de erro retornadas pelos validadores são o contrato verificado pelos testes. Ao alterar um texto de mensagem em `validador_auth.dart` (ou similar), o teste correspondente e a documentação de casos de teste precisam ser atualizados junto — caso contrário a especificação e a implementação divergem silenciosamente.

## Segurança: leia antes de subir para o GitHub

Durante a organização deste projeto, foi encontrada uma **chave privada real do Firebase Admin SDK commitada no repositório** (fora da pasta `backend/`, com um nome de arquivo ligeiramente diferente do padrão esperado). Isso dá acesso administrativo total ao projeto Firebase para qualquer pessoa com acesso ao repositório.

Se você ainda não fez isso:

1. No [Firebase Console](https://console.firebase.google.com) → Configurações do projeto → Contas de serviço, **revogue/exclua** a chave exposta e gere uma nova.
2. Remova o arquivo do **histórico** do Git (apagar num commit novo não é suficiente — ele continua acessível no histórico). Use [`git filter-repo`](https://github.com/newren/git-filter-repo) ou o [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/), depois `git push --force`.
3. Confira se o `.gitignore` da raiz do projeto e o de `backend/` cobrem o nome real do seu arquivo de credencial antes de adicioná-lo novamente.

## Erros comuns

| Sintoma | Causa provável | Solução |
| --- | --- | --- |
| "Não foi possível conectar ao servidor" no app | Backend não está rodando, ou `baseUrl` errado | Confirme que `npm run dev` está ativo e que o `baseUrl` bate com o ambiente (tabela acima) |
| Erro de CORS no navegador | Não deveria acontecer — o backend libera todas as origens por padrão | Confirme que está batendo na porta certa (padrão `3000`) |
| `Cannot find module '../config/db'` ou erro parecido ao rodar o backend | Algum arquivo aponta para um módulo com nome diferente do real | Já corrigido nesta versão; se acontecer de novo, confira se o nome do `require(...)` bate com o arquivo em `src/config/` |
| App trava ao salvar um registro emocional sem selecionar emoji/cor | Bug já corrigido nesta versão (emoji e cor são opcionais, mas o código antigo exigia os dois) | Se estiver usando uma cópia antiga do projeto, atualize `emotional_record_screen.dart` |
| `flutter test` falha ao importar `registro_emocional_screen.dart` | Nome antigo de arquivo, já renomeado para `emotional_record_screen.dart` | Já corrigido nesta versão |

## O que falta fazer

Lista de continuação, em ordem sugerida de prioridade:

1. **Rotacionar a credencial do Firebase exposta** (ver seção de Segurança) — item de segurança, não de funcionalidade, mas é o mais urgente.
2. **OTP real**: criar uma tabela para códigos de verificação, gerar/enviar o código por e-mail (ex.: com Nodemailer ou um serviço como SendGrid) e trocar o `if (codigo === '123456')` fixo em `authController.js` por uma consulta real.
3. **Persistir o registro emocional no backend**: hoje fica só no dispositivo (`shared_preferences`). Existe um esqueleto em `backend/src/controllers/humorController.js` que precisa de uma tabela `registros_emocionais` no banco e de ser registrado em uma rota.
4. **Chatbot com IA real**: trocar o motor de respostas local por uma chamada a um endpoint do próprio backend (que guarda a chave de API em segredo e repassa para o provedor de IA escolhido).
5. **Integração de saúde (BPM/passos)**: o arquivo `frontend/lib/screens/health_service.dart` já contém a implementação, mas está **comentado/desativado**, pois depende do pacote `health` e de configuração nativa (Android: Health Connect + `FlutterFragmentActivity`; iOS: capability HealthKit). O passo a passo para ativar está no topo do próprio arquivo. Enquanto isso, o monitor usa BPM simulado.
6. **Áudio real** para meditações/sleepcasts, usando `just_audio` + `audio_service`.

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software  · ICET/UFAM</sub>
</div>
