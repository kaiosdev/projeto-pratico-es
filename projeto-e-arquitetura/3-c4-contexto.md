<div align="center">
  <h1 style="color: #1a73e8;">🗺️ DESCRIÇÃO DO DIAGRAMA DE CONTEXTO C4: SLOW DOWN</h1>
  <p><i>Nível 1 (Contexto) — Revisão Sprint 2 — Engenharia de Software A</i></p>

  <img src="https://img.shields.io/badge/Status-Concluído-blue?style=for-the-badge" alt="Status">

  <br><br>

  | Campo | Informação |
  |:---|:---|
  | **Responsáveis** | Marcos Oliveira e Marcelo Barros |
  | **Projeto** | SlowDown |
  | **Metodologia** | Modelo C4 — Simon Brown |
  | **Nível C4** | Contexto (Nível 1) |
  | **Status da Entrega** | Concluído |

</div>

---

## 1. Sobre o Diagrama de Contexto

O **Diagrama de Contexto C4** representa o **Nível 1** do modelo C4, proposto por Simon Brown. Seu objetivo é delimitar as fronteiras do sistema, que faz parte do software que estamos construindo e identificar os atores externos que interagem com ele, sejam pessoas (usuários) ou sistemas externos (dependências técnicas).

O diagrama é organizado em **três camadas verticais** sobre fundo quadriculado:

| Camada | Conteúdo |
|:---|:---|
| **Superior** | 3 personas (usuários) conectadas ao sistema central via setas rotuladas *"Acessa"* |
| **Central** | Sistema SlowDown — hub integrador de todas as conexões |
| **Inferior** | 6 sistemas externos em duas fileiras, com setas tracejadas e rótulos por tipo de integração |

---
# Diagrama de Contexto
<img width="1131" height="832" alt="Diagrama de Contexto-Página-2 drawio (3)" src="https://github.com/user-attachments/assets/fa273aa5-bedf-4077-b3b7-2a92f0fc27db" />


## 2. Atores — Personas do Sistema

As três personas foram definidas durante a fase de Design Thinking (documento `2_design-thinking.md`) e são os principais motivadores das decisões arquiteturais do projeto.

### 👤 Geilson Alves — [Persona 1] · Plano Premium

Representa trabalhadores de atividade física intensa como operários rurais, técnicos industriais e profissionais do agronegócio que atuam frequentemente em regiões com conectividade instável ou ausente. É o principal motivador do modo offline nativo (US-18) e da integração com a Google Fit API (US-04).

### 👤 Arleson Mota — [Persona 2] · Plano Padrão

Gestor de equipes que utiliza o SlowDown tanto para cuidar da própria saúde mental quanto para acompanhar o bem-estar dos colaboradores sob sua supervisão. Utiliza relatórios semanais e mensais (US-09) e o recurso de Pessoa Próxima (US-10).

### 👤 Ana Beatriz Lemos — [Persona 3] · Acessibilidade

Profissional de tecnologia com alta carga cognitiva, que enfrenta dificuldade em desconectar ao fim do expediente. Motiva diretamente a integração com o Google Speech-to-Text para navegação por comandos de voz (US-04 do backlog original).

---

## 3. Sistema Central

### SLOW DOWN — [App Mobile]

> Aplicativo de prevenção de burnout ocupacional. É o **hub integrador** do diagrama — recebe as conexões das três personas via setas sólidas rotuladas *"Acessa"* e distribui para os seis sistemas externos via setas tracejadas com rótulos específicos de relacionamento.

Conforme documentado no Plano de Trabalho (`1_plano-de-trabalho.md`), o sistema é voltado à **prevenção e identificação precoce da Síndrome de Burnout** antes que ela se torne incapacitante, com suporte offline nativo como diferencial central.

| Atributo | Descrição |
|:---|:---|
| **Plataforma** | Mobile (Android — MVP) |
| **Modo Offline** | Nativo — funcionalidades essenciais sem internet |
| **Engajamento** | Gamificação com missões, XP e pet virtual |
| **Acessibilidade** | Navegação por voz e integração biométrica |

---

## 4. Sistemas Externos — Fileira A

### 🔐 Serviço de Autenticação — [Software System]

**Firebase Auth / OAuth 2.0.** Responsável pelo cadastro seguro, login e gerenciamento de sessões dos usuários. Cobre a US-15 (criar conta e fazer login no aplicativo).

- **Rótulo da seta:** *Consome*

---

### 🔔 Serviço de Notificações Push — [Software System]

**Firebase Cloud Messaging (FCM).** Envia lembretes personalizados de missões diárias, alertas de bem-estar e incentivos para manutenção do hábito de autocuidado. Cobre a US-14 (configurar notificações personalizadas).

- **Rótulo da seta:** *Recebe alertas de*

---

### 💳 Gateway de Pagamento — [Software System]

**Stripe API (Sandbox).** Processa assinaturas do plano premium e eventuais compras in-app. Ambiente de testes para o MVP Android. As referências anteriores a Google Play Billing e Apple IAP foram removidas nesta revisão, pois o MVP roda exclusivamente no Android. Cobre a US-16 (upgrade para plano premium).

- **Rótulo da seta:** *Processa compras via*

---

## 5. Sistemas Externos — Fileira B

### 🤖 Chatbot — [Software System]

**Gemini API.** Alimenta o chatbot interativo com respostas personalizadas baseadas no histórico emocional do usuário, oferecendo sugestões de conteúdo e incentivo adaptado ao estado atual de cada persona. Cobre a US-07 (interagir com chatbot de incentivo personalizado). A referência genérica anterior "API de LLM" foi substituída especificamente por Gemini API nesta revisão.

- **Rótulo da seta:** *Consome*

---

### 💓 Google Fit API — [Software System] ⭐ *Novo*

**Sistema externo adicionado na revisão do Sprint 2.** Coleta dados biométricos, especialmente a frequência cardíaca, para enriquecer o monitoramento de estresse do usuário. Obrigatório para a US-04. Motivado pela persona Geilson, que realiza atividade física intensa em campo.

- **Rótulo da seta:** *Consome dados biométricos*

---

### 🎙️ Google Speech-to-Text — [Software System] ⭐ *Novo*

**Sistema externo adicionado na revisão do Sprint 2.** Realiza a conversão de comandos de voz em texto, sendo essencial para a acessibilidade da Ana Beatriz. Alinha-se diretamente à característica inovadora de *"Integração de Voz"* registrada na seção 2.3 do Plano de Trabalho como diferencial do projeto. Cobre a US-05.

- **Rótulo da seta:** *Converte áudio*

---

## 6. Alterações em Relação à Versão Anterior

| # | Tipo | Elemento | Descrição da Alteração |
|:---|:---|:---|:---|
| 1 | 🔴 Removido | Plataforma de Streaming de Áudio | APIs externas de streaming exigem conexão constante, quebrando a regra de funcionamento offline (US-18). Os conteúdos de meditação, playlists e sleepcasts (US-01, US-02, US-17) passam a ser gerenciados internamente pelo app. |
| 2 | 🟡 Atualizado | Gateway de Pagamento | Google Play Billing e Apple IAP removidos. O MVP usa exclusivamente **Stripe API (Sandbox)** para o ambiente Android. |
| 3 | 🟡 Atualizado | Chatbot | Referência genérica "API de LLM" substituída especificamente por **Gemini API**, tornando a dependência técnica rastreável. |
| 4 | 🟢 Adicionado | Google Fit API | Nova dependência obrigatória para US-04. Coleta dados biométricos (frequência cardíaca). Motivada pela persona Geilson. |
| 5 | 🟢 Adicionado | Google Speech-to-Text | Nova dependência para US-05. Conversão de voz em texto para acessibilidade da Ana Beatriz. Diferencial inovador registrado no Plano de Trabalho. |

---

## 7. Convenções Visuais

| Elemento | Representação |
|:---|:---|
| **Personas** | Caixas azul escuro com foto, nome, plano e descrição. Ícones de silhueta humana. |
| **Sistema central** | Caixa azul médio, maior e centralizada, com tag `[App Mobile]`. |
| **Sistemas externos (existentes)** | Caixas cinza claro com tag `[Software System]` e descrição técnica. |
| **Sistemas externos (novos)** | Mesma estrutura dos existentes; adicionados na fileira B nesta revisão. |
| **Setas personas → sistema** | Sólidas, rótulo *"Acessa"*. |
| **Setas sistema → externos** | Tracejadas, com rótulos específicos por tipo de integração. |
| **Fundo** | Grade quadriculada — padrão Draw.io para documentação técnica. |

---

## 8. Rastreabilidade com o Backlog do Produto

| Sistema Externo | User Story | Prioridade | Persona(s) |
|:---|:---|:---|:---|
| Serviço de Autenticação | US-15 — Criar conta e fazer login | 🔥 Alta | Geilson, Ana, Arleson |
| Serviço de Notificações Push | US-14 — Configurar notificações personalizadas | 🔥 Alta | Ana, Geilson |
| Gateway de Pagamento (Stripe) | US-16 — Visualizar e assinar plano premium | 🟡 Média | Ana, Arleson |
| Chatbot (Gemini API) | US-07 — Interagir com chatbot de incentivo | 🔥 Alta | Ana, Geilson |
| Google Fit API | US-04 — Navegação por comandos de voz / biométrica | 🟡 Média | Arleson |
| Google Speech-to-Text | US-05 — Registrar estado emocional diariamente | 🔥 Alta | Ana, Geilson |

---

<div align="center">

  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>

</div>
