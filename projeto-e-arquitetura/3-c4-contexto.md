<div align="center">
  <h1 style="color: #1a73e8;">🗺️ DIAGRAMA DE CONTEXTO C4: SLOW DOWN</h1>
  <p><i>Nível 1 — Contexto do Sistema — Engenharia de Software A</i></p>

  <img src="https://img.shields.io/badge/Status-Concluído-blue?style=for-the-badge" alt="Status">

  <br><br>

  | Campo | Informação |
  |:---|:---|
  | **Responsáveis** | Marcelo Barros |
  | **Projeto** | Slow Down |
  | **Nível C4** | Contexto (Nível 1) |
  | **Status da Entrega** | Concluído |

</div>

---

## 1. VISÃO GERAL DO SISTEMA

O **Slow Down** é um aplicativo móvel voltado à prevenção do burnout ocupacional. No nível de contexto C4, descrevemos quem interage com o sistema e com quais serviços externos ele se comunica, sem entrar em detalhes de arquitetura interna.

---
## Sobre o Diagrama de Contexto

O **Diagrama de Contexto C4** representa o **Nível 1** do modelo C4, proposto por Simon Brown. Seu objetivo é delimitar as fronteiras do sistema, que faz parte do software que estamos construindo e identificar os atores externos que interagem com ele, sejam pessoas (usuários) ou sistemas externos (dependências técnicas).

O diagrama é organizado em **três camadas verticais** sobre fundo quadriculado:

| Camada | Conteúdo |
|:---|:---|
| **Superior** | 3 personas (usuários) conectadas ao sistema central via setas rotuladas *"Acessa"* |
| **Central** | Sistema Slow Down — hub integrador de todas as conexões |
| **Inferior** | 6 sistemas externos em duas fileiras, com setas tracejadas e rótulos por tipo de integração |

---

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

### 💓 Google Fit API — [Software System] 

**Sistema externo adicionado na revisão do Sprint 2.** Coleta dados biométricos, especialmente a frequência cardíaca, para enriquecer o monitoramento de estresse do usuário. Obrigatório para a US-04. Motivado pela persona Geilson, que realiza atividade física intensa em campo.

- **Rótulo da seta:** *Consome dados biométricos*

---

### 🎙️ Google Speech-to-Text — [Software System] 

**Sistema externo adicionado na revisão do Sprint 2.** Realiza a conversão de comandos de voz em texto, sendo essencial para a acessibilidade da Ana Beatriz. Alinha-se diretamente à característica inovadora de *"Integração de Voz"* registrada na seção 2.3 do Plano de Trabalho como diferencial do projeto. Cobre a US-05.

- **Rótulo da seta:** *Converte áudio*

---

## 6. DIAGRAMA DE CONTEXTO C4

> O diagrama abaixo ilustra as relações entre os usuários, o sistema Slow Down e os sistemas externos integrados.
<img width="1131" height="832" alt="Diagrama de Contexto-Página-2 drawio (3)" src="https://github.com/user-attachments/assets/fa273aa5-bedf-4077-b3b7-2a92f0fc27db" />


**Legenda:**

| Elemento | Descrição |
|:---|:---|
| 🟦 **Usuário (Pessoa)** | Ator humano que interage diretamente com o sistema |
| 🟩 **SlowDown (Sistema)** | O sistema central que está sendo modelado |
| 🟨 **Sistema Externo** | Serviço de terceiros com o qual o SlowDown se integra |
| **→ Seta sólida** | Interação principal (uso direto do sistema) |
| **→ Seta tracejada** | Integração com sistema externo |

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>

---

