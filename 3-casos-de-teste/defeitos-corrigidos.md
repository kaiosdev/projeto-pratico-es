<div align="center">

# 🛠️ Relatório de Correção de Defeitos — SlowDown

*Engenharia de Software A · ICET/UFAM*

![Fase](https://img.shields.io/badge/Fase-Inspeção_TP3-4a90d9?style=for-the-badge&logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge)

</div>

## 1. Visão Geral da Inspeção

Este documento detalha o processo de **Correção dos Defeitos** identificados durante a inspeção de requisitos do Trabalho Prático III. O objetivo é apresentar as análises realizadas, os problemas encontrados e as soluções implementadas para aprimorar a qualidade e a clareza das *User Stories* (US) do backlog do projeto.

> **Nota de Classificação:** As validações aplicadas neste relatório filtraram os falsos positivos e utilizaram rigorosamente a taxonomia oficial de defeitos de software (Omissão, Ambiguidade, Inconsistência, Fato Incorreto e Informação Estranha).

## 2. Detalhamento das Correções Implementadas

### 2.1 US 01 — Sessões de Meditação Guiada

O primeiro conjunto de correções focou na clareza e no contexto da funcionalidade de meditação guiada, garantindo o alinhamento exclusivo para a Persona Premium.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **1** | Inconsistência | 🔴 Falso Positivo | Conflito sugerido entre o ambiente rural da Persona e o termo "pausas de trabalho". | O trabalho rural possui pausas naturais. A semântica não afeta a arquitetura e foi mantida. |
| **2** | Ambiguidade | 🟢 Corrigido | A expressão "pausada a qualquer momento" não definia o estado de persistência do app. | Critério atualizado para especificar salvamento em cache local e expiração após 2h de inatividade. |
| **3** | Omissão | 🟢 Corrigido | O termo "locutor configuráveis" omitia quais parâmetros técnicos estariam disponíveis. | História alterada para refletir a ação exata esperada: "seleção do perfil de voz". |
| **4** | Info. Estranha | 🟢 Corrigido | A regra original detalhava limites para contas *Free* em uma US exclusiva Premium. | A regra restritiva gratuita foi removida por ser desnecessária ao escopo do plano pago. |

### 2.2 US 02 — Playlists de Relaxamento Offline

Nesta etapa, as correções ajustaram as regras de download e introduziram requisitos não-funcionais sobre o gerenciamento de arquivos físicos no dispositivo.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **5** | Ambig. / Omissão | 🟢 Corrigido | A regra de "limite de 1 playlist" omitia o ciclo de vida do arquivo (exclusão e troca). | Adicionados Critérios de Aceitação detalhando a possibilidade de remoção do download para liberar espaço. |
| **6** | Omissão | 🟢 Corrigido | O requisito não definia os limites relacionados ao armazenamento físico do dispositivo. | Inclusão de critério que interrompe o download e exibe imediatamente o alerta de "Espaço Insuficiente". |
| **7** | Ambiguidade | 🔴 Falso Positivo | O termo "playlist relaxante" foi apontado como uma característica subjetiva e ambígua. | O termo é tratado como uma *tag* de banco de dados. Ajustado para "curadoria de relaxamento" por precisão. |

### 2.3 US 03 — Pet Virtual Inclusivo

As correções implementadas nesta User Story garantiram a inclusão de requisitos não-funcionais de acessibilidade e a manutenção da integridade das lógicas de engajamento.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **8** | Omissão / Ambig. | 🟢 Corrigido | Permitir renomear o pet "a qualquer momento" expunha o sistema a falhas de notificação e perda de métricas. | Atualizado para estipular um intervalo de carência (*cooldown*) rigoroso de 7 dias entre cada alteração de nome. |
| **9** | Omissão | 🟢 Corrigido | O backlog destina a US à Persona de Acessibilidade, mas omitia o suporte a tecnologias assistivas. | Inclusão de requisitos exigindo rótulos semânticos (*labels*) compatíveis com leitores de tela e comandos de voz. |

### 2.4 US 04 — Monitoramento Cardíaco

Os ajustes focaram no desempenho da bateria de dispositivos móveis e na conformidade legal para o processamento de dados médicos.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **10** | Ambig. / Omissão | 🟢 Corrigido | Omitia os valores limite da "faixa saudável" e como o usuário faria essa configuração. | Inclusão de parâmetros médicos (ex: alertas para < 60 ou > 100 BPM) e permissão de personalização de perfil. |
| **11** | Ambiguidade | 🟢 Corrigido | O termo "em tempo real" não especificava a taxa de amostragem biométrica. | Substituído pela arquitetura de "intervalos de amostragem fixos" (ex: a cada 10 minutos) em processamento de segundo plano. |
| **12** | Omissão | 🟢 Corrigido | O requisito omitia a obtenção do consentimento legal para o processamento de dados de saúde. | Adição de Regra de Negócio exigindo o aceite explícito do Termo de Consentimento para adequação à LGPD. |

### 2.5 H16-2 — Autenticação de Usuário e Cadastro

O refinamento desta etapa garantiu segurança na validação de usuários, integração com provedores externos e correções organizacionais da rastreabilidade.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **13** | Omissão | 🟢 Corrigido | A regra de senha complexa omitia o tratamento para o fluxo de login social (Google OAuth). | Contas geradas via Google OAuth foram configuradas para dispensar a etapa de criação de senha local no banco de dados. |
| **14** | Omissão | 🟢 Corrigido | O termo "valida o e-mail" omitia o método técnico, tempo de expiração e o comportamento de reenvio. | Definido o uso obrigatório de código numérico (OTP) de 6 dígitos, com expiração de 15 minutos e botão de reenvio. |
| **15** | Fato Incorreto | 🟢 Corrigido | Falha de gestão e duplicação de rastreabilidade (duas histórias diferentes cadastradas como US-16). | A história foi formalmente rebatizada e documentada como **H16-2**, garantindo identificação unívoca no repositório. |

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>
