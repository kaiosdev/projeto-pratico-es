<div align="center">

# 🏗️ DIAGRAMA DE CÓDIGO (ESTRUTURAL) C4: SLOW DOWN
*Nível 4 — Diagrama de Classes UML — Engenharia de Software A*

<img src="https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge" alt="Status">

<br><br>

| Campo | Informação |
|:---|:---|
| **Responsáveis** | Nádia Leão |
| **Projeto** | SlowDown |
| **Nível C4** | Código / Estrutural (Nível 4) |
| **Status da Entrega** | Concluído |

</div>

---

## 1. OBJETIVO DO NÍVEL DE CÓDIGO

O **Diagrama de Código** representa o **Nível 4** do modelo C4. Neste nível, detalhamos a estrutura interna do sistema por meio de um **Diagrama de Classes UML**, que representa as principais entidades do domínio do SlowDown, seus atributos, métodos e os relacionamentos entre elas.

As classes estão diretamente alinhadas com:
- Os **componentes** identificados no Nível 3 (documento `5-c4-componentes.md`)
- As **entidades do banco de dados** (camada Model — MySQL)
- As **Histórias de Usuário** do TP1 (documento `3_backlog-do-produto.md`)

---

## 2. VISÃO GERAL DAS CLASSES PRINCIPAIS

O diagrama contempla as seguintes classes de domínio do SlowDown:

| Classe | Camada MVC | Responsabilidade Principal |
|:---|:---:|:---|
| `User` | Model | Perfil, credenciais e plano do usuário |
| `EmotionalLog` | Model | Registro emocional diário com dados biométricos |
| `Insight` | Model | Resultado gerado pelo InsightEngine para um usuário |
| `Mission` | Model | Definição de uma missão de autocuidado |
| `UserMission` | Model | Progresso de um usuário em uma missão específica |
| `Achievement` | Model | Emblema conquistado por um usuário |
| `Pet` | Model | Estado do pet virtual associado ao usuário |
| `AudioContent` | Model | Metadados de sessão de meditação ou paisagem sonora |
| `NotificationSetting` | Model | Preferências de notificação de um usuário |
| `Subscription` | Model | Status de assinatura e plano do usuário |
| `AuthController` | Controller | Fluxo de autenticação e sessão |
| `EmotionalLogController` | Controller | Registro e consulta de estados emocionais |
| `ChatbotController` | Controller | Interação com o chatbot via Gemini API |
| `MissionController` | Controller | Ciclo de vida de missões e distribuição de XP |
| `XPEngine` | Controller | Cálculo de XP e evolução do pet |

---

## 3. DIAGRAMA DE CLASSES UML — VISÃO GERAL

### 3.1 Visão geral do diagrama

A **Figura 1** apresenta o diagrama de classes completo do núcleo de domínio do SlowDown. Ele reúne as **10 classes de Model** (entidades persistidas no MySQL) e as **7 classes de Controller** (componentes identificados no Nível 3), evidenciando como `User` atua como ponto de convergência de praticamente todas as entidades do sistema, e como os controllers se relacionam com os models por **associação de uso** (dependência), nunca por herança — refletindo o padrão MVC adotado.

Antes de detalhar partes específicas (Seção 4), recomenda-se uma leitura geral: do lado esquerdo/centro estão as classes de **Model**, todas gravitando em torno de `User`; do lado direito estão as classes de **Controller**, que orquestram a lógica de negócio e dependem das classes de Model para ler e persistir dados.

```mermaid
classDiagram

    %% ─────────────────────────────────────────────
    %% CLASSES DE MODELO (ENTIDADES DE DOMÍNIO)
    %% ─────────────────────────────────────────────

    class User {
        +String id
        +String name
        +String email
        +String passwordHash
        +String plan
        +DateTime createdAt
        +DateTime lastLogin
        +register(name, email, password) Boolean
        +login(email, password) String
        +updateProfile(data) Boolean
        +getPlan() String
    }

    class EmotionalLog {
        +String id
        +String userId
        +Int emotionalLevel
        +Int bpm
        +String notes
        +DateTime registeredAt
        +save() Boolean
        +getHistory(userId, days) List~EmotionalLog~
        +getAverage(userId, days) Float
    }

    class Insight {
        +String id
        +String userId
        +String content
        +String source
        +DateTime generatedAt
        +generate(userId, context) Insight
        +getLatest(userId) List~Insight~
    }

    class Mission {
        +String id
        +String title
        +String description
        +String category
        +Int xpReward
        +Boolean isPremium
        +listAvailable(plan) List~Mission~
        +getById(id) Mission
    }

    class UserMission {
        +String id
        +String userId
        +String missionId
        +String status
        +DateTime startedAt
        +DateTime completedAt
        +start(userId, missionId) Boolean
        +complete(userId, missionId) Boolean
        +getProgress(userId) List~UserMission~
    }

    class Achievement {
        +String id
        +String userId
        +String title
        +String description
        +String badgeUrl
        +DateTime unlockedAt
        +unlock(userId, achievementId) Boolean
        +getByUser(userId) List~Achievement~
    }

    class Pet {
        +String id
        +String userId
        +String name
        +Int level
        +Int currentXP
        +String equippedItem
        +rename(name) Boolean
        +addXP(amount) Boolean
        +levelUp() Boolean
        +equipItem(itemId) Boolean
        +getState(userId) Pet
    }

    class AudioContent {
        +String id
        +String title
        +String type
        +String narrator
        +Int durationSeconds
        +String audioUrl
        +Boolean isPremium
        +listByType(type, plan) List~AudioContent~
        +getById(id) AudioContent
    }

    class NotificationSetting {
        +String id
        +String userId
        +String type
        +String scheduledTime
        +Boolean isEnabled
        +save(userId, settings) Boolean
        +getByUser(userId) NotificationSetting
        +toggle(userId, type, enabled) Boolean
    }

    class Subscription {
        +String id
        +String userId
        +String plan
        +String status
        +DateTime startDate
        +DateTime endDate
        +String stripeCustomerId
        +upgrade(userId, plan) Boolean
        +cancel(userId) Boolean
        +getStatus(userId) Subscription
        +isActive(userId) Boolean
    }

    %% ─────────────────────────────────────────────
    %% CLASSES DE CONTROLE (CONTROLLERS)
    %% ─────────────────────────────────────────────

    class AuthController {
        -FirebaseAuth firebaseAuth
        +register(name, email, password) String
        +login(email, password) String
        +logout(userId) Boolean
        +validateToken(token) Boolean
        +refreshToken(token) String
    }

    class EmotionalLogController {
        -EmotionalLog logModel
        -InsightEngine insightEngine
        +createLog(userId, level, bpm, notes) EmotionalLog
        +getHistory(userId, days) List~EmotionalLog~
        +getStressIndex(userId) Float
        +triggerInsight(userId) Insight
    }

    class ChatbotController {
        -GeminiAPI geminiApi
        -EmotionalLog logModel
        +sendMessage(userId, message) String
        +buildPrompt(userId, message) String
        +getConversationHistory(userId) List
    }

    class InsightEngine {
        -EmotionalLog logModel
        -GeminiAPI geminiApi
        +generateInsight(userId) Insight
        +analyzePattern(userId, days) String
        +callGeminiForInsight(context) String
    }

    class MissionController {
        -Mission missionModel
        -UserMission userMissionModel
        -XPEngine xpEngine
        +listMissions(userId) List~Mission~
        +startMission(userId, missionId) Boolean
        +completeMission(userId, missionId) Boolean
        +getDailyProgress(userId) List~UserMission~
    }

    class XPEngine {
        -Pet petModel
        -Achievement achievementModel
        +addXP(userId, amount) Boolean
        +checkLevelUp(userId) Boolean
        +checkAchievements(userId) List~Achievement~
        +getLevel(userId) Int
    }

    class NotificationController {
        -NotificationSetting settingModel
        -FCMService fcmService
        +saveSettings(userId, settings) Boolean
        +scheduleNotification(userId, type, time) Boolean
        +sendPushNotification(userId, message) Boolean
        +cancelNotification(userId, type) Boolean
    }

    class SubscriptionController {
        -Subscription subscriptionModel
        -StripeAPI stripeApi
        +getPlans() List
        +upgrade(userId, planId) Boolean
        +cancelSubscription(userId) Boolean
        +checkAccess(userId, feature) Boolean
    }

    %% ─────────────────────────────────────────────
    %% RELACIONAMENTOS
    %% ─────────────────────────────────────────────

    %% User como centro do domínio
    User "1" --> "0..*" EmotionalLog : registra
    User "1" --> "1" Pet : possui
    User "1" --> "0..*" UserMission : participa de
    User "1" --> "0..*" Achievement : conquista
    User "1" --> "1" NotificationSetting : configura
    User "1" --> "1" Subscription : assina
    User "1" --> "0..*" Insight : recebe

    %% Mission e UserMission
    Mission "1" --> "0..*" UserMission : compõe
    UserMission "0..*" --> "1" User : pertence a

    %% Controllers e Models
    AuthController ..> User : gerencia
    EmotionalLogController ..> EmotionalLog : persiste
    EmotionalLogController ..> InsightEngine : aciona
    InsightEngine ..> EmotionalLog : analisa
    InsightEngine ..> Insight : gera
    ChatbotController ..> EmotionalLog : consulta
    MissionController ..> Mission : consulta
    MissionController ..> UserMission : atualiza
    MissionController ..> XPEngine : aciona
    XPEngine ..> Pet : evolui
    XPEngine ..> Achievement : verifica/desbloqueia
    NotificationController ..> NotificationSetting : persiste
    SubscriptionController ..> Subscription : gerencia
    SubscriptionController ..> User : verifica plano

    %% AudioContent
    AudioContent "0..*" ..> Subscription : requer plano Premium
```

**Figura 1 — Diagrama de Classes UML completo do núcleo de domínio do SlowDown, com as classes de Model (entidades persistidas) e de Controller (componentes do Nível 3) e seus relacionamentos.**

---

## 4. DETALHAMENTO POR PARTES

A Figura 1 reúne todas as classes do domínio, o que pode dificultar a leitura de fluxos específicos. As subseções abaixo recortam o diagrama geral em três visões focadas, cada uma acompanhada de uma figura específica, conforme as áreas funcionais já apresentadas no Nível 3 (`5-c4-componentes.md`).

### 4.1 Parte 1 — User como Centro do Domínio

A classe `User` é o **núcleo central** do modelo de domínio do SlowDown. Todas as entidades relevantes do sistema possuem associação direta ou indireta com ela.

```mermaid
classDiagram
    class User {
        +String id
        +String name
        +String email
        +String passwordHash
        +String plan
        +DateTime createdAt
        +DateTime lastLogin
        +register(name, email, password) Boolean
        +login(email, password) String
        +updateProfile(data) Boolean
        +getPlan() String
    }

    class EmotionalLog {
        +String userId
    }

    class Pet {
        +String userId
    }

    class UserMission {
        +String userId
    }

    class Achievement {
        +String userId
    }

    class NotificationSetting {
        +String userId
    }

    class Subscription {
        +String userId
    }

    class Insight {
        +String userId
    }

    User "1" --> "0..*" EmotionalLog : registra
    User "1" --> "1" Pet : possui
    User "1" --> "0..*" UserMission : participa de
    User "1" --> "0..*" Achievement : conquista
    User "1" --> "1" NotificationSetting : configura
    User "1" --> "1" Subscription : assina
    User "1" --> "0..*" Insight : recebe
```

**Figura 2 — `User` como centro do domínio: cada usuário registra logs emocionais, possui um pet, participa de missões, conquista emblemas, configura notificações, assina um plano e recebe insights.**

- Um `User` **registra** múltiplos `EmotionalLog` ao longo do tempo — permitindo rastrear a evolução emocional (US-06, US-10).
- Um `User` **possui** exatamente um `Pet`, que evolui conforme o usuário completa missões (US-03, US-13).
- Um `User` **participa de** múltiplas `UserMission`, que rastreiam seu progresso individual nas missões disponíveis (US-13).
- Um `User` **conquista** múltiplos `Achievement` ao atingir metas de autocuidado (US-12).
- Um `User` **configura** uma única `NotificationSetting` com suas preferências de alertas (US-15).
- Um `User` **assina** um `Subscription`, que determina o acesso a funcionalidades Premium (US-17).

---

### 4.2 Parte 2 — Bem-estar Emocional e IA (Controllers x Models)

Os **Controllers** não herdam das entidades de modelo — eles as utilizam por **dependência (associação de uso)**. Isso reflete o padrão MVC adotado: os controllers orquestram o fluxo, mas não carregam estado de domínio. Esta visão foca no fluxo de registro emocional, geração de insights e chatbot.

```mermaid
classDiagram
    class EmotionalLog {
        +String id
        +String userId
        +Int emotionalLevel
        +Int bpm
        +String notes
        +DateTime registeredAt
        +save() Boolean
        +getHistory(userId, days) List~EmotionalLog~
        +getAverage(userId, days) Float
    }

    class Insight {
        +String id
        +String userId
        +String content
        +String source
        +DateTime generatedAt
        +generate(userId, context) Insight
        +getLatest(userId) List~Insight~
    }

    class EmotionalLogController {
        -EmotionalLog logModel
        -InsightEngine insightEngine
        +createLog(userId, level, bpm, notes) EmotionalLog
        +getHistory(userId, days) List~EmotionalLog~
        +getStressIndex(userId) Float
        +triggerInsight(userId) Insight
    }

    class InsightEngine {
        -EmotionalLog logModel
        -GeminiAPI geminiApi
        +generateInsight(userId) Insight
        +analyzePattern(userId, days) String
        +callGeminiForInsight(context) String
    }

    class ChatbotController {
        -GeminiAPI geminiApi
        -EmotionalLog logModel
        +sendMessage(userId, message) String
        +buildPrompt(userId, message) String
        +getConversationHistory(userId) List
    }

    EmotionalLogController ..> EmotionalLog : persiste
    EmotionalLogController ..> InsightEngine : aciona
    InsightEngine ..> EmotionalLog : analisa
    InsightEngine ..> Insight : gera
    ChatbotController ..> EmotionalLog : consulta
```

**Figura 3 — Fluxo de Bem-estar Emocional e IA: o `EmotionalLogController` persiste registros e aciona o `InsightEngine`, que analisa o histórico e gera `Insight`; o `ChatbotController` consulta o mesmo histórico para montar o contexto enviado à Gemini API.**

- `EmotionalLogController` cria logs e aciona o `InsightEngine`, que analisa padrões e pode chamar a Gemini API para insights mais elaborados.
- `InsightEngine` lê `EmotionalLog` e produz instâncias de `Insight`, associadas ao usuário.
- `ChatbotController` consulta o mesmo histórico de `EmotionalLog` para enriquecer o contexto enviado ao modelo de linguagem.

---

### 4.3 Parte 3 — Gamificação e Controle de Acesso Premium

Esta visão foca no ciclo de gamificação (missões → XP → pet → conquistas) e no papel da `Subscription` como guardiã de acesso a conteúdo Premium.

```mermaid
classDiagram
    class Mission {
        +String id
        +String title
        +String category
        +Int xpReward
        +Boolean isPremium
        +listAvailable(plan) List~Mission~
        +getById(id) Mission
    }

    class UserMission {
        +String id
        +String userId
        +String missionId
        +String status
        +start(userId, missionId) Boolean
        +complete(userId, missionId) Boolean
        +getProgress(userId) List~UserMission~
    }

    class Pet {
        +String id
        +String userId
        +Int level
        +Int currentXP
        +addXP(amount) Boolean
        +levelUp() Boolean
        +getState(userId) Pet
    }

    class Achievement {
        +String id
        +String userId
        +String title
        +unlock(userId, achievementId) Boolean
        +getByUser(userId) List~Achievement~
    }

    class Subscription {
        +String id
        +String userId
        +String plan
        +String status
        +isActive(userId) Boolean
    }

    class AudioContent {
        +String id
        +Boolean isPremium
        +listByType(type, plan) List~AudioContent~
    }

    class MissionController {
        -Mission missionModel
        -UserMission userMissionModel
        -XPEngine xpEngine
        +listMissions(userId) List~Mission~
        +startMission(userId, missionId) Boolean
        +completeMission(userId, missionId) Boolean
        +getDailyProgress(userId) List~UserMission~
    }

    class XPEngine {
        -Pet petModel
        -Achievement achievementModel
        +addXP(userId, amount) Boolean
        +checkLevelUp(userId) Boolean
        +checkAchievements(userId) List~Achievement~
        +getLevel(userId) Int
    }

    class SubscriptionController {
        -Subscription subscriptionModel
        -StripeAPI stripeApi
        +getPlans() List
        +upgrade(userId, planId) Boolean
        +cancelSubscription(userId) Boolean
        +checkAccess(userId, feature) Boolean
    }

    Mission "1" --> "0..*" UserMission : compõe
    MissionController ..> Mission : consulta
    MissionController ..> UserMission : atualiza
    MissionController ..> XPEngine : aciona
    XPEngine ..> Pet : evolui
    XPEngine ..> Achievement : verifica/desbloqueia
    SubscriptionController ..> Subscription : gerencia
    AudioContent "0..*" ..> Subscription : requer plano Premium
```

**Figura 4 — Gamificação e controle de acesso Premium: o `MissionController` atualiza `UserMission` e aciona o `XPEngine`, que evolui o `Pet` e verifica novas `Achievement`; o `SubscriptionController` gerencia a `Subscription`, da qual depende o acesso a `AudioContent` marcado como Premium.**

- `MissionController` gerencia o ciclo de missões e chama o `XPEngine` ao completar uma missão.
- `XPEngine` atualiza o `Pet` e verifica se novas conquistas foram desbloqueadas via `Achievement`.
- A classe `Subscription` atua como **guardiã de acesso** a funcionalidades Premium. O `SubscriptionController.checkAccess(userId, feature)` é chamado pelos demais controllers antes de liberar recursos exclusivos como download offline (US-02), missões premium e áudios especiais (US-18).

---

## 5. RASTREABILIDADE COM O BACKLOG

| Classe / Método Principal | HU Relacionada | Funcionalidade |
|:---|:---|:---|
| `User.register()` / `AuthController.register()` | US-16 | Criação de conta |
| `User.login()` / `AuthController.login()` | US-16 | Login seguro |
| `EmotionalLog.save()` / `EmotionalLogController.createLog()` | US-06 | Registro emocional |
| `InsightEngine.generateInsight()` | US-07 | Insights personalizados |
| `ChatbotController.sendMessage()` | US-08 | Chatbot de apoio |
| `Mission.listAvailable()` / `MissionController.listMissions()` | US-13 | Missões diárias |
| `UserMission.complete()` / `XPEngine.addXP()` | US-13 | Conclusão e XP |
| `XPEngine.checkAchievements()` / `Achievement.unlock()` | US-12 | Emblemas digitais |
| `Pet.addXP()` / `Pet.levelUp()` | US-03, US-13 | Evolução do pet virtual |
| `NotificationController.scheduleNotification()` | US-15 | Notificações personalizadas |
| `SubscriptionController.upgrade()` | US-17 | Assinatura Premium |
| `Subscription.isActive()` | US-02, US-17, US-18 | Controle de acesso Premium |
| `AudioContent.listByType()` | US-01, US-18 | Sessões de meditação e áudio |

---

<div align="center">

<sub>Desenvolvido para a disciplina de Engenharia de Software A · ICET/UFAM<br>
Professor: Dr. Andrey Rodrigues</sub>

</div>

