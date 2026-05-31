<div align="center">
  <h1 style="color: #1a73e8;">🗺️ DIAGRAMA DE CONTEXTO C4: SLOW DOWN</h1>
  <p><i>Nível 1 — Contexto do Sistema — Engenharia de Software A</i></p>

  <img src="https://img.shields.io/badge/Status-Concluído-blue?style=for-the-badge" alt="Status">

  <br><br>

  | Campo | Informação |
  |:---|:---|
  | **Responsáveis** | Marcos Oliveira e Marcelo Barros |
  | **Projeto** | SlowDown |
  | **Nível C4** | Contexto (Nível 1) |
  | **Status da Entrega** | Concluído |

</div>

---

## 1. VISÃO GERAL DO SISTEMA

O **SlowDown** é um aplicativo móvel voltado à prevenção do burnout ocupacional. No nível de contexto C4, descrevemos quem interage com o sistema e com quais serviços externos ele se comunica, sem entrar em detalhes de arquitetura interna.

---

## 2. ATORES DO SISTEMA

O ecossistema do SlowDown é composto por três perfis de usuário e um conjunto de integrações externas que viabilizam as funcionalidades principais da plataforma.

### 👷 Geilson Alves — Usuário Trabalhador de Campo (Plano Premium)

Geilson representa trabalhadores de atividade física intensa — como operários rurais, técnicos industriais e profissionais do agronegócio — que atuam frequentemente em regiões com conectividade instável ou ausente. Ele acessa o SlowDown principalmente para sessões de meditação guiada, playlists offline e o monitoramento diário do seu termômetro emocional. Sua interação com o sistema é direta via aplicativo móvel, com forte dependência do **modo offline nativo** para garantir continuidade de uso mesmo sem internet. O pet virtual e as missões de XP são elementos-chave de engajamento para esse perfil.

### 🧑‍💼 Arleson Mota — Usuário Gestor (Plano Padrão)

Arleson é um gestor de equipes que utiliza o SlowDown tanto para cuidar da própria saúde mental quanto para acompanhar o bem-estar dos colaboradores sob sua supervisão. Ele acessa relatórios semanais e mensais de picos de estresse, interage com o chatbot para orientações personalizadas e utiliza o recurso de **apoio a pessoa próxima** para monitorar colegas em sofrimento emocional. A navegação por **comandos de voz** é um diferencial importante para Arleson, que frequentemente usa o app com as mãos ocupadas durante reuniões ou deslocamentos. Ele representa o perfil corporativo do produto.

### 👩‍💻 Ana Beatriz Lemos — Usuária de Tecnologia (Foco em Acessibilidade)

Ana é uma profissional de tecnologia com alta carga cognitiva, que enfrenta dificuldade em desconectar ao fim do expediente. Ela utiliza o SlowDown para registrar seu estado emocional diário, consumir sleepcasts antes de dormir, completar missões de autocuidado e eventualmente considerar o upgrade para o plano premium. Para Ana, a experiência de onboarding fluido, as notificações personalizadas e a integração com serviços de streaming de áudio são os pontos de maior valor. Ela também representa os usuários que mais se beneficiam da acessibilidade da interface e dos recursos de voz.

---

## 3. INTEGRAÇÕES COM SISTEMAS EXTERNOS

O SlowDown se conecta a quatro categorias de serviços externos para operar suas funcionalidades principais:

**Serviço de Autenticação (ex.: Firebase Auth / OAuth 2.0):** Responsável pelo cadastro seguro, login e gerenciamento de sessões dos usuários. Toda a identidade digital e histórico de bem-estar é protegido por esse serviço, que garante que Ana, Arleson e Geilson acessem apenas seus próprios dados.

**Plataforma de Streaming de Áudio (ex.: API de áudio):** Fornece os conteúdos de meditação guiada, playlists relaxantes e sleepcasts que formam o coração da experiência auditiva do app. O sistema baixa e armazena esses conteúdos localmente para garantir o funcionamento offline — especialmente crítico para Geilson em campo.

**Serviço de Notificações Push (ex.: Firebase Cloud Messaging):** Envia lembretes personalizados de missões diárias, alertas de bem-estar e incentivos para manutenção do hábito de autocuidado. Ana configura os horários dessas notificações para que se encaixem na sua rotina, enquanto Arleson pode receber alertas relacionados ao monitoramento de equipe.

**Gateway de Pagamento (ex.: Stripe / Google Play Billing / Apple IAP):** Processa as assinaturas do plano premium e eventuais compras in-app. Arleson e Ana podem fazer upgrade pelo próprio aplicativo, com a transação sendo processada de forma segura por esse serviço externo.

**Motor de IA / Chatbot (ex.: API de LLM):** Alimenta o chatbot interativo com respostas personalizadas baseadas no histórico emocional do usuário, oferecendo sugestões de conteúdo e incentivo adaptado ao estado atual de cada persona.

---

## 4. DIAGRAMA DE CONTEXTO C4

> O diagrama abaixo ilustra as relações entre os usuários, o sistema SlowDown e os sistemas externos integrados.

<img width="1416" height="886" alt="Diagrama de Contexto-Página-2 drawio (2)" src="https://github.com/user-attachments/assets/ce60dbd9-6c61-4976-99b1-b4db87ab3cbf" />


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
