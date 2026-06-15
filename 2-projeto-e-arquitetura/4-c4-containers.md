<div align="center">

# 📦 DIAGRAMA DE CONTAINERS C4: SLOW DOWN
*Nível 2 — Arquitetura de Containers — Engenharia de Software A*

<img src="https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge" alt="Status">

| Campo | Informação |
|:---|:---|
| **Responsável** | Marcos Oliveira |
| **Projeto** | SlowDown |
| **Nível C4** | Containers (Nível 2) |
| **Status da Entrega** | Concluído |

</div>

## 1. OBJETIVO DO NÍVEL DE CONTAINERS

Neste nível da modelagem C4, "abrimos" o sistema central do **SlowDown** (apresentado no Nível 1) para detalhar seus contêineres internos. O objetivo é demonstrar as responsabilidades do aplicativo móvel, da API de backend e do banco de dados, além de detalhar como eles interagem entre si e com os sistemas externos utilizando protocolos específicos.

## 2. ARQUITETURA INTERNA (OS CONTAINERS)

O sistema SlowDown é composto por três contêineres principais, organizados de forma modular para garantir escalabilidade, manutenibilidade e integração com serviços externos especializados.

### 📱 1. Aplicativo Mobile (View / Cliente)

- **Tecnologia:** Flutter (Dart).
- **Responsabilidade:** Fornecer a interface de interação com o usuário em dispositivos Android. Permite o registro e acompanhamento do bem-estar emocional, gerenciamento do Pet Virtual, execução de missões diárias, visualização de estatísticas e utilização dos recursos de acessibilidade.
- **Comunicação:** Realiza chamadas HTTPS/JSON para a API Backend, integra-se ao Google Speech-to-Text para conversão de áudio em texto e acessa recursos nativos do dispositivo, como microfone e sensores de atividade física por meio do Google Fit API.

### ⚙️ 2. API REST Backend (Controller)

- **Tecnologia:** Node.js com Express.
- **Responsabilidade:** Centralizar as regras de negócio do sistema. Gerencia autenticação, perfis de usuários, cálculo do Índice de Estresse, gamificação, missões diárias, histórico emocional, funcionamento do chatbot, processamento das informações recebidas pelo aplicativo e integração com serviços externos.
- **Comunicação:** Recebe requisições HTTP/JSON do Aplicativo Mobile, realiza operações de leitura e escrita no Banco de Dados, integra-se ao Firebase Authentication para gerenciamento de usuários, ao Stripe API para processamento de pagamentos e comunica-se com a Gemini API para funcionalidades inteligentes.

### 🗄️ 3. Banco de Dados Relacional

- **Tecnologia:** MySQL
- **Responsabilidade:** Armazenar de forma estruturada e persistente todas as informações do sistema, incluindo perfis de usuários, registros emocionais, histórico de atividades, progresso no Pet Virtual, missões diárias e dados de gamificação.
- **Comunicação:** Recebe conexões seguras exclusivamente da API Backend para operações de consulta, inserção, atualização e remoção de dados.

### 🔗 Integrações Externas
O sistema utiliza serviços externos especializados para ampliar suas funcionalidades:
- **Firebase Authentication:** Responsável pela autenticação e gerenciamento de contas dos usuários.
- **Google Fit API:** Fornece dados relacionados à atividade física e saúde do usuário.
- **Google Speech-to-Text:** Realiza a conversão de comandos de voz em texto para utilização nos recursos do sistema.
- **Gemini API:** Disponibiliza os modelos de Inteligência Artificial para análise emocional e funcionamento do chatbot.
- **Stripe API:** Responsável pelo processamento de pagamentos e assinaturas premium.
- **Firebase Cloud Messaging:** Utilizado para envio de notificações push, lembretes e mensagens motivacionais aos usuários.

### 🔄 Fluxo Geral de Funcionamento

- O usuário interage com o Aplicativo Mobile.
- O aplicativo envia requisições para a API Backend utilizando HTTPS/JSON.
- A API Backend processa as regras de negócio e consulta o Banco de Dados quando necessário.
- Para funcionalidades específicas, o Backend utiliza serviços externos, como autenticação, IA generativa, notificações, pagamentos e coleta de dados físicos.
- Os resultados são retornados ao Aplicativo Mobile e apresentados ao usuário.

## 3. DIAGRAMA DE CONTAINERS C4

> O diagrama abaixo ilustra a estrutura interna de contêineres do SlowDown e o fluxo de dados com os serviços externos.

<div align="center">
  <img width="1529" height="1039" alt="Diagrama de containers" src="https://github.com/user-attachments/assets/ae6097bb-7ea1-40d1-8190-efa964f1870c" />
  <p><i><b>Figura 1:</b> Diagrama de Containers do Aplicativo SlowDown.</i></p>
</div>

**Legenda:**

| Elemento | Descrição |
|:---|:---|
| 🔵 **Usuário (Pessoa)** | Ator humano que interage com o sistema |
| 🟦 **Container** | Contêineres que compõem o próprio SlowDown |
| 🟨 **Sistema Externo** | Serviços e APIs de terceiros |
| **→ Setas de Fluxo** | Direção da comunicação e protocolo utilizado (ex: JSON/HTTPS) |

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>
