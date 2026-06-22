<div align="center">

# 🧘 Slow Down
*Aplicativo de Apoio ao Cuidado contra o Burnout*

<img src="https://img.shields.io/badge/Status-Trabalho_Prático_III-blue?style=for-the-badge" alt="Status">
<img src="https://img.shields.io/badge/Engenharia_de_Software_A-ICET--UFAM-green?style=for-the-badge" alt="Disciplina">

</div>

## 📝 Sobre o Projeto

O **Slow Down** é uma solução móvel voltada à prevenção e controle do burnout ocupacional, desenhada para trabalhadores de diversos setores. O sistema integra monitoramento de saúde, gamificação e suporte offline, garantindo bem-estar mesmo em ambientes com conectividade limitada.

> **Problema Central:** O burnout é um fenômeno ocupacional reconhecido pela OMS. O aplicativo atua na prevenção silenciosa do esgotamento, oferecendo suporte acessível antes que o estresse se torne incapacitante.

## 🚀 Principais Funcionalidades

- **Mascote Virtual (Tamagotchi):** Pet personalizável que evolui conforme o autocuidado.
- **Missões Diárias e XP:** Sistema de tarefas que gera pontos de experiência para desbloquear itens.
- **Sistema de Conquistas:** Emblemas digitais, como o "Mente Blindada", ao atingir metas de saúde mental.
- **Monitoramento Emocional:** Termômetro diário integrado com dados de frequência cardíaca (BPM) via **Google Fit**.
- **Conteúdo em Áudio:** Sleepcasts e meditações com suporte a download para modo offline.
- **Assistente via IA:** Chatbot integrado com **Gemini API** para incentivo personalizado e análise de estresse.
- **Acessibilidade:** Navegação *hands-free* via comandos de voz (**Google Speech-to-Text**).

## 🏛️ Arquitetura

O sistema segue o padrão **Model-View-Controller (MVC)** e a modelagem arquitetural **C4**, garantindo escalabilidade e separação de responsabilidades.

### 💻 Stack Tecnológica
- **Frontend:** Flutter (Foco em Android e operação offline).
- **Backend:** Node.js com Express (API REST).
- **Banco de Dados:** MySQL.
- **Serviços:** Firebase Auth, Firebase Cloud Messaging, Stripe API (Sandbox).

## 📁 Estrutura do Repositório

### 📌 TP1 — Especificação
| Arquivo | Descrição |
| :--- | :--- |
| [1_plano-de-trabalho.md](1-especificacao/1_plano-de-trabalho.md) | Escopo, tecnologias e papéis da equipe. |
| [2_design-thinking.md](1-especificacao/2_design-thinking.md) | Golden Circle, SWOT e Personas. |
| [3_backlog-do-produto.md](1-especificacao/3_backlog-do-produto.md) | Lista priorizada de Histórias de Usuário. |
| [4_backlog-do-sprint.md](1-especificacao/4_backlog-do-sprint.md) | Planejamento e Backlog da Sprint. |

### 🏗️ TP2 — Arquitetura C4
| Arquivo | Descrição |
| :--- | :--- |
| [1-padroes-arquiteturais.md](2-projeto-e-arquitetura/1-padroes-arquiteturais.md) | Definição do padrão MVC. |
| [2-tech-stack.md](2-projeto-e-arquitetura/2-tech-stack.md) | Mapeamento detalhado das tecnologias. |
| [3-c4-contexto.md](2-projeto-e-arquitetura/3-c4-contexto.md) | Nível 1: Contexto do sistema. |
| [4-c4-containers.md](2-projeto-e-arquitetura/4-c4-containers.md) | Nível 2: Arquitetura de containers. |
| [5-c4-componentes.md](2-projeto-e-arquitetura/5-c4-componentes.md) | Nível 3: Diagrama de componentes. |
| [6-c4-codigo.md](2-projeto-e-arquitetura/6-c4-codigo.md) | Nível 4: Diagrama de classes UML. |
| [7-rastreabilidade.md](2-projeto-e-arquitetura/7-rastreabilidade.md) | Matriz de rastreabilidade (HUs x Arquitetura). |

### 🧪 TP3 — Testes de Software
| Arquivo / Pasta | Descrição |
| :--- | :--- |
| [defeitos-corrigidos.md](3-casos-de-teste/defeitos-corrigidos.md) | Relatório de Inspeção e Correção de Defeitos do Backlog. |
| [classes-equivalencia.md](3-casos-de-teste/classes-equivalencia.md) | Projeto de Casos de Teste Funcionais (Técnica Caixa Preta). |
| [relatorio-de-testes.md](3-casos-de-teste/relatorio-de-testes.md) | Relatório de Execução e Status Final dos Testes. |
| [`frontend/`](3-casos-de-teste/frontend) | Diretório com o código-fonte do MVP do aplicativo. |
| [`tests/`](3-casos-de-teste/tests) | Diretório contendo os scripts de testes automatizados (Dart/Flutter). |

## 👥 Equipe do Projeto

<table align="center">
  <tr>
    <td align="center"><a href="https://github.com/kaiosdev"><img src="https://github.com/kaiosdev.png" width="100px;" alt=""/><br /><sub><b>Kaio Sobral Moreira</b></sub></a><br />Scrum Master / Tech Stack </td>
    <td align="center"><a href="https://github.com/FelipeRangelSilvestre"><img src="https://github.com/FelipeRangelSilvestre.png" width="100px;" alt=""/><br /><sub><b>Felipe Rangel</b></sub></a><br />Rastreabilidade (HUs x Arquitetura)</td>
    <td align="center"><a href="https://github.com/marcox-oliveira"><img src="https://github.com/marcox-oliveira.png" width="100px;" alt=""/><br /><sub><b>Marcos Oliveira</b></sub></a><br />Arquitetura C4 / Modelagem Geral</td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/Evelly-Siqueira"><img src="https://github.com/Evelly-Siqueira.png" width="100px;" alt=""/><br /><sub><b>Evelly Rebeca</b></sub></a><br />Documentação Técnica / UI-UX</td>
    <td align="center"><a href="https://github.com/nadileao"><img src="https://github.com/nadileao.png" width="100px;" alt=""/><br /><sub><b>Nádia Leão</b></sub></a><br />Modelagem C4 / Diagramas UML</td>
    <td align="center"><a href="https://github.com/marecelobarrosdasilva-bit"><img src="https://github.com/marecelobarrosdasilva-bit.png" width="100px;" alt=""/><br /><sub><b>Marcelo Barros</b></sub></a><br />Personas / Design Thinking</td>
  </tr>
</table>

## 🔗 Links de Gestão

- **[Quadro de Backlog (GitHub Projects)](https://github.com/users/kaiosdev/projects/5)**
- **[Quadro de Sprints (GitHub Projects)](https://github.com/users/kaiosdev/projects/6)**
- **[Documentação no Notion](https://olive-ankle-b99.notion.site/337b9fbbb879804d8201d7467ea98f58)**

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A · ICET/UFAM<br>
  Professor: Dr. Andrey Rodrigues</sub>
</div>
