<div align="center">

# 📦 DIAGRAMA DE CONTAINERS C4: SLOW DOWN
*Nível 2 — Arquitetura de Containers — Engenharia de Software A*

<img src="https://img.shields.io/badge/Status-Em_Desenvolvimento-2e7d32?style=for-the-badge" alt="Status">

<br><br>

| Campo | Informação |
|:---|:---|
| **Responsáveis** | Marcos Oliveira e Marcelo Barros |
| **Projeto** | SlowDown |
| **Nível C4** | Containers (Nível 2) |
| **Status da Entrega** | Pendente (Aguardando Imagem) |

</div>

---

## 1. OBJETIVO DO NÍVEL DE CONTAINERS

Neste nível da modelagem C4, "abrimos" o sistema central do **SlowDown** (apresentado no Nível 1) para detalhar seus contêineres internos. O objetivo é demonstrar as responsabilidades do aplicativo móvel, da API de backend e do banco de dados, além de detalhar como eles interagem entre si e com os sistemas externos utilizando protocolos específicos.

---

## 2. ARQUITETURA INTERNA (OS CONTAINERS)

O sistema SlowDown é composto por três contêineres principais, estruturados de acordo com o padrão arquitetural MVC:

### 📱 1. Aplicativo Mobile (View / Cliente)
*   **Tecnologia:** Flutter (Dart).
*   **Responsabilidade:** Fornecer a interface nativa com o usuário (Android). Gerencia o cache local de arquivos de áudio para o modo offline, captura interações (como o termômetro emocional) e renderiza a gamificação do Pet Virtual.
*   **Comunicação:** Comunica-se diretamente com o hardware nativo (Google Fit API, Microfone) e realiza chamadas assíncronas para o Backend e Firebase.

### ⚙️ 2. API REST Backend (Controller)
*   **Tecnologia:** Node.js com Express.
*   **Responsabilidade:** Atuar como o núcleo lógico do sistema. Valida sessões, executa o motor de cálculo do Índice de Estresse, distribui pontos de experiência (XP) e processa os comandos de voz e texto.
*   **Comunicação:** Recebe requisições HTTP/JSON do aplicativo, coordena integrações externas (Gemini API, Stripe) e lê/escreve informações na camada de persistência.

### 🗄️ 3. Banco de Dados Relacional (Model)
*   **Tecnologia:** MySQL.
*   **Responsabilidade:** Armazenar de forma estruturada e durável as informações críticas do sistema, incluindo perfis de usuários, registros históricos de saúde mental, inventários do Pet Virtual e logs de missões diárias.
*   **Comunicação:** Recebe conexões seguras (via TCP/IP) exclusivas do contêiner da API REST Backend.

---

## 3. DIAGRAMA DE CONTAINERS C4

> O diagrama abaixo ilustra a estrutura interna de contêineres do SlowDown e o fluxo de dados com os serviços externos.
<<img width="1813" height="1052" alt="container" src="https://github.com/user-attachments/assets/c38bbd91-6348-441a-9c29-f9dd456b56e1" />
<!-- A equipe de design inserirá a imagem final do diagrama aqui -->
<div align="center">
  <p><i>[ ⚠️ Imagem do Diagrama C4 Nível 2 será inserida aqui pelos Arquitetos ]</i></p>
</div>

**Legenda:**

| Elemento | Descrição |
|:---|:---|
| 🟦 **Usuário (Pessoa)** | Ator humano que interage com o sistema |
| 🔵 **Container (Azul Escuro)** | Contêineres que compõem o próprio SlowDown |
| 🟨 **Sistema Externo** | Serviços e APIs de terceiros |
| **→ Setas de Fluxo** | Direção da comunicação e protocolo utilizado (ex: JSON/HTTPS) |

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>
