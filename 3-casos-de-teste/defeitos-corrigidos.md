<div align="center">

# 🛠️ Relatório de Inspeção e Casos de Teste — SlowDown

*Engenharia de Software A · ICET/UFAM*

![Fase](https://img.shields.io/badge/Fase-Inspeção_e_Testes-4a90d9?style=for-the-badge&logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge)

</div>

## 1. Visão Geral do Documento

Este documento centraliza as etapas de **Garantia de Qualidade (QA)** do Trabalho Prático III. Ele detalha o processo de **Correção de Defeitos** identificados na inspeção do Backlog, seguido imediatamente pelo **Projeto de Casos de Teste (Caixa Preta)** derivado dessas correções.

> **Nota de Metodologia:** As correções filtraram os falsos positivos e utilizaram a taxonomia oficial de defeitos (Omissão, Ambiguidade, Inconsistência, Fato Incorreto e Informação Estranha). Os Casos de Teste foram modelados utilizando a técnica de *Particionamento em Classes de Equivalência*, isolando as classes inválidas para garantir precisão na detecção de falhas.

### 1.1 Resumo Quantitativo de Inspeção
- **Total de Apontamentos Avaliados:** 31
- **🟢 Defeitos Corrigidos:** 29
- **🔴 Apontamentos Desconsiderados (Falsos Positivos):** 2

---

## 2. Rastreabilidade: Defeitos e Casos de Teste

### 2.1 US-01 — Sessões de Meditação Guiada

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **1** | Inconsistência | 🔴 Falso Positivo | Conflito sugerido entre o ambiente rural da Persona e o termo "pausas de trabalho". | O trabalho rural possui pausas naturais. A semântica não afeta a arquitetura e foi mantida. |
| **2** | Ambiguidade | 🟢 Corrigido | A expressão "pausada a qualquer momento" não definia o estado de persistência do app. | Deixamos claro que o app salva onde a pessoa parou, mas se ela fechar o app ou sumir por 2 horas, a sessão expira. |
| **3** | Omissão | 🟢 Corrigido | O termo "locutor configuráveis" omitia quais parâmetros técnicos estariam disponíveis. | Trocamos o termo vago para refletir exatamente o que o usuário vai fazer: "seleção do perfil de voz". |
| **4** | Info. Estranha | 🟢 Corrigido | A regra original detalhava limites para contas *Free* em uma US exclusiva Premium. | Removemos essa regra, já que não faz sentido falar de limites gratuitos numa funcionalidade que é toda paga. |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Duração da Sessão | Valor pertence ao conjunto: 5, 10, 15, 20 (1) | Valor fora do conjunto (2) | Valor nulo ou vazio (3) |
| Locutor | Locutor do catálogo selecionado (4) | Nenhum locutor selecionado (5) | — |
| Tipo de Assinatura | Usuário com plano Premium ativo (6) | Usuário com plano Free/Gratuito (7) | Conta não autenticada (8) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 6 | Duração: 10; Locutor: Voz Serenidade; Plano: Premium | Sessão iniciada com sucesso |
| **Caso 2** | 2, 4, 6 | Duração: 7; Locutor: Voz Serenidade; Plano: Premium | Sistema impede início e exibe erro de duração |
| **Caso 3** | 3, 4, 6 | Duração: Nulo; Locutor: Voz Serenidade; Plano: Premium | Sistema impede início por campo obrigatório ausente |
| **Caso 4** | 1, 5, 6 | Duração: 10; Locutor: Nulo; Plano: Premium | Sistema solicita seleção obrigatória do locutor |
| **Caso 5** | 1, 4, 7 | Duração: 10; Locutor: Voz Serenidade; Plano: Free | Sistema bloqueia acesso e exibe paywall do Premium |

---

### 2.2 US-02 — Playlists de Relaxamento Offline

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **5** | Ambig. / Omissão | 🟢 Corrigido | A regra de "limite de 1 playlist" omitia o ciclo de vida do arquivo (exclusão e troca). | Adicionamos critérios permitindo que o usuário apague a playlist baixada a qualquer momento. |
| **6** | Omissão | 🟢 Corrigido | O requisito não definia os limites relacionados ao armazenamento físico do dispositivo. | Colocamos uma trava: se o celular estiver cheio, o app interrompe o download na hora. |
| **7** | Ambiguidade | 🔴 Falso Positivo | O termo "playlist relaxante" foi apontado como subjetivo. | Isso é só uma tag no banco de dados. Ajustamos levemente para "curadoria de relaxamento". |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Espaço de Armazenamento | Espaço livre $\ge$ tamanho do arquivo (1) | Espaço livre < tamanho do arquivo (2) | — |
| Estado da Conexão | Conectado à Internet (Wi-Fi ou Dados) (3) | Sem conexão / Modo Avião (4) | — |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3 | Arquivo: 50MB; Espaço: 2000MB; Rede: Conectada | Download autorizado e playlist salva na seção Offline |
| **Caso 2** | 2, 3 | Arquivo: 50MB; Espaço: 10MB; Rede: Conectada | Download bloqueado e sistema alerta espaço insuficiente |
| **Caso 3** | 1, 4 | Arquivo: 50MB; Espaço: 2000MB; Rede: Offline | Sistema bloqueia tentativa e solicita conexão |

---

### 2.3 US-03 — Pet Virtual Inclusivo

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **8** | Omissão / Ambig. | 🟢 Corrigido | Permitir renomear o pet "a qualquer momento" expunha o sistema a falhas. | Criamos um "tempo de recarga" (cooldown) de 7 dias antes de poder trocar o nome. |
| **9** | Omissão | 🟢 Corrigido | O backlog destina a US à Persona de Acessibilidade, mas omitia o suporte tecnológico. | Exigimos que todos os botões tenham leitura em áudio (labels) e suporte a comandos de voz. |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Tempo desde alteração | Tempo $\ge$ 7 dias (1) | Tempo < 7 dias (2) | — |
| Nome do Pet | Texto entre 1 e 20 caracteres (3) | Campo vazio (4) | Texto com mais de 20 caracteres (5) |
| Felicidade | Login em 48 horas ou menos (6) | Inatividade superior a 48 horas (7) | — |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 6 | Tempo: 8 dias; Nome: Buddy; Inatividade: 24h | Nome alterado com sucesso e felicidade mantida |
| **Caso 2** | 2, 3, 6 | Tempo: 3 dias; Nome: Buddy; Inatividade: 24h | Sistema impede alteração devido a período de carência |
| **Caso 3** | 1, 4, 6 | Tempo: 8 dias; Nome: Vazio; Inatividade: 24h | Sistema impede salvamento por campo em branco |
| **Caso 4** | 1, 5, 6 | Tempo: 8 dias; Nome: TextoLongo...; Inatividade: 24h | Sistema impede salvamento por limite de caracteres |
| **Caso 5** | 1, 3, 7 | Tempo: 8 dias; Nome: Buddy; Inatividade: 50h | Nome alterado, mas Pet perde 1 nível de felicidade |

---

### 2.4 US-04 — Monitoramento Cardíaco

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **10** | Ambig. / Omissão | 🟢 Corrigido | Omitia os valores limite da "faixa saudável" e a configuração do usuário. | Definimos os alertas padrão (abaixo de 60 ou acima de 100 BPM), com personalização livre. |
| **11** | Ambiguidade | 🟢 Corrigido | O termo "em tempo real" drenaria a bateria por falta de taxa de amostragem. | Trocamos por verificações de segundo plano (ex: a cada 10 minutos). |
| **12** | Omissão | 🟢 Corrigido | Omitia a obtenção do consentimento legal para processamento de dados médicos. | O app vai exigir um "aceito" da LGPD antes de guardar os dados. |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Frequência (BPM) | Batimentos entre 60 e 100 BPM (1) | Abaixo de 60 BPM (2) | Acima de 100 BPM (3) |
| Amostragem | Tempo configurado $\ge$ 600s (4) | Tempo configurado < 600s (5) | Valor de tempo nulo/negativo (6) |
| Permissão SO | Sensores de saúde concedidos (7) | Sensores negados (8) | — |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7 | BPM: 85; Intervalo: 600s; Sensor: Permitido | Registro normal; nenhum alerta disparado |
| **Caso 2** | 2, 4, 7 | BPM: 45; Intervalo: 600s; Sensor: Permitido | Sistema dispara alerta de repouso crítico |
| **Caso 3** | 3, 4, 7 | BPM: 115; Intervalo: 600s; Sensor: Permitido | Sistema dispara alerta de taquicardia |
| **Caso 4** | 1, 5, 7 | BPM: 85; Intervalo: 30s; Sensor: Permitido | Sistema rejeita configuração para prevenir dreno |
| **Caso 5** | 1, 6, 7 | BPM: 85; Intervalo: -10s; Sensor: Permitido | Sistema exibe erro de formato de tempo |
| **Caso 6** | 1, 4, 8 | BPM: 85; Intervalo: 600s; Sensor: Negado | Suspende o monitoramento e solicita permissão |

---

### 2.5 US-06 — Registro Emocional Diário

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **13** | Ambiguidade | 🟢 Corrigido | A notificação chegar "ao final do dia" é extremamente subjetivo. | O usuário escolherá o horário nas configurações, com as 20h00 como padrão de fábrica. |
| **14** | Inconsistência | 🟢 Corrigido | Regras de negócio duplicadas e em texto livre soltas na descrição. | Retiramos as informações duplicadas e centralizamos tudo nas regras formais. |
| **15** | Ambiguidade | 🟢 Corrigido | História usava o ator genérico "usuário". | Direcionamos a história exatamente para a nossa Persona Ana (Acessibilidade). |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Método de Registro | Emoji, cor ou escala válidos (1) | Nenhum método selecionado (2) | Método não suportado (3) |
| Nota Textual | Texto com até 500 caracteres (4) | Texto com > 500 caracteres (5) | Dado incompatível com texto (6) |
| Registro Diário | Primeiro registro do dia (7) | Registro atualizado na mesma data (8) | Tentativa de criar 2 registros na mesma data (9) |
| Horário da Notificação| Horário válido (10) | Horário inexistente (11) | Formato inválido (12) |
| Sincronização | Usuário com sincronização válida (13) | Usuário sem conexão (14) | Falha por dados inconsistentes (15) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 13 | Emoji válido, 100 caracteres, 1º registro, horário padrão, conectado | Registro salvo e sincronizado |
| **Caso 2** | 2, 4, 7, 10, 13 | Nenhum método selecionado | Sistema impede o registro |
| **Caso 3** | 3, 4, 7, 10, 13 | Método não suportado | Sistema rejeita o registro |
| **Caso 4** | 1, 5, 7, 10, 13 | Nota com > 500 caracteres | Sistema informa o limite permitido |
| **Caso 5** | 1, 6, 7, 10, 13 | Dado incompatível na nota | Sistema rejeita o registro |
| **Caso 6** | 1, 4, 8, 10, 13 | Novo registro na mesma data | Sistema substitui o registro existente |
| **Caso 7** | 1, 4, 9, 10, 13 | Segundo registro sem atualização | Sistema bloqueia a criação |
| **Caso 8** | 1, 4, 7, 11, 13 | Horário inexistente configurado | Sistema rejeita a configuração |
| **Caso 9** | 1, 4, 7, 12, 13 | Formato inválido configurado | Erro de validação de horário |
| **Caso 10** | 1, 4, 7, 10, 14 | Sem conexão com internet | Salvo localmente, sincronização adiada |
| **Caso 11** | 1, 4, 7, 10, 15 | Falha de dados inconsistentes | Salvo localmente, erro de sincronização registrado |

---

### 2.6 US-07 — Termômetro Emocional com Insights

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **16** | Omissão | 🟢 Corrigido | "Insights personalizados" escondia a lógica do algoritmo. | Detalhamos como o sistema vai ler o histórico para gerar as dicas. |
| **17** | Ambiguidade | 🟢 Corrigido | "Preferências do usuário" permitia muitas interpretações. | Mapeamos quais parâmetros do perfil o app realmente vai usar (idade, plano, etc). |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Qtde. de registros | $\ge$ 3 registros na semana (1) | < 3 registros na semana (2) | Não possui registros (3) |
| Perfil (Sugestões) | Perfil completo (4) | Preferência não informada (5) | Disponibilidade não informada (6) |
| Tipo de Usuário | Premium acessando insights (7) | Free acessando insights (8) | Sem identificação de plano (9) |
| Filtro de Evolução | Filtro por semana ou mês (10) | Filtro inexistente (11) | Filtro não suportado (12) |
| Origem dos Dados | Dados do próprio app (13) | Exclusivamente de terceiros (14) | Fontes externas não permitidas (15) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 13 | 5 registros, perfil completo, Premium, filtro semanal, dados do app | Resumo e gráfico gerados corretamente |
| **Caso 2** | 2, 4, 7, 10, 13 | Apenas 2 registros na semana | Não gera resumo e informa quantos faltam |
| **Caso 3** | 3, 4, 7, 10, 13 | Sem registros na semana | Não gera resumo por ausência |
| **Caso 4** | 1, 5, 7, 10, 13 | Sem preferência de bem-estar | Solicita preenchimento antes de gerar |
| **Caso 5** | 1, 6, 7, 10, 13 | Sem disponibilidade de tempo | Solicita preenchimento antes de gerar |
| **Caso 6** | 1, 4, 8, 10, 13 | Usuário gratuito tenta acessar | Bloqueia e informa recurso Premium |
| **Caso 7** | 1, 4, 9, 10, 13 | Sem plano válido identificado | Impede acesso aos insights avançados |
| **Caso 8** | 1, 4, 7, 11, 13 | Filtro inexistente | Rejeita e exibe erro |
| **Caso 9** | 1, 4, 7, 12, 13 | Filtro não suportado | Solicita filtro válido |
| **Caso 10**| 1, 4, 7, 10, 14 | Apenas dados de terceiros | Desconsidera dados externos |
| **Caso 11**| 1, 4, 7, 10, 15 | Dados misturados não permitidos | Usa apenas dados locais (ou bloqueia) |

---

### 2.7 US-08 — Chatbot Interativo com Incentivo

#### 🐛 Correção de Defeitos
*(Sem inspeção reportada. Os testes foram derivados diretamente da especificação validada do backlog).*

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Estilo de Orientação | Bíblico, psicológico, motivacional (1) | Nenhum (campo vazio) (2) | Fora das opções (ex: clínico) (3) |
| Conteúdo (Mensagem)| Mensagem sem crise explícita (4) | Vazia/espaços (5) | Relato explícito de suicídio (6) |
| Indicadores de Crise | Nenhum indicador no histórico (7) | Palavra-chave de crise (8) | Incapacidade $>$ 7 dias no histórico (9) |
| Acesso ao Histórico | Autenticado no próprio histórico (10) | Não autenticado tenta acesso (11) | Tenta acessar histórico de outro (12) |
| Conteúdo Sensível | Tristeza sem crise aguda (13) | Relato de abuso em curso (14) | Manifestação de pânico (15) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 13 | Estilo psicológico; "Estou ansioso"; sem crise | Chatbot responde no tom; salva histórico |
| **Caso 2** | 2, 4, 7, 10, 13 | Estilo vazio | Bloqueia envio e solicita estilo |
| **Caso 3** | 3, 4, 7, 10, 13 | Estilo "clínico" | Rejeita estilo informado |
| **Caso 4** | 1, 5, 7, 10, 13 | Mensagem vazia | Bloqueia o envio |
| **Caso 5** | 1, 6, 7, 10, 13 | Relato de automutilação | Protocolo clínico acionado; CVV 188 exibido |
| **Caso 6** | 1, 4, 8, 10, 13 | Palavra-chave de crise aguda | Protocolo clínico acionado |
| **Caso 7** | 1, 4, 9, 10, 13 | Histórico com 8 dias de incapacidade | Protocolo clínico acionado via histórico |
| **Caso 8** | 1, 4, 7, 11, 13 | Não autenticado tenta acessar | Acesso negado |
| **Caso 9** | 1, 4, 7, 12, 13 | Acesso a histórico de terceiro | Acesso negado por permissão |
| **Caso 10**| 1, 4, 7, 10, 14 | Relato de abuso em curso | Protocolo clínico acionado |
| **Caso 11**| 1, 4, 7, 10, 15 | Crise de pânico em tempo real | Protocolo clínico acionado |

---

### 2.8 US-09 — Mini Games Antiestresse

#### 🐛 Correção de Defeitos
*(Sem inspeção reportada. Os testes foram derivados diretamente da especificação validada do backlog).*

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Tipo de Usuário | Premium irrestrito (1) | Free na janela de 24h (1 sessão) (2) | Free com sessão diária encerrada (3) |
| Duração da Sessão | Entre 2 e 5 minutos (4) | Antes de 2 minutos (5) | Ultrapassando 5 min sem fechamento (6) |
| Tipo de Interação | Até 2 tipos distintos sem combo (7) | Mais de 2 tipos (8) | Combinação simultânea (9) |
| Elementos Competitivos| Sem pontuação/pressão (10) | Com pontuação competitiva (11) | Com elementos de pressão (12) |
| Acessibilidade | Offline / sem áudio obrigatório (13)| Exige internet para funcionar (14) | Exige áudio (impede uso silencioso) (15)|

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 13 | Premium; 3 min; offline/silencioso | Game executado plenamente |
| **Caso 2** | 2, 4, 7, 10, 13 | Free (1ª sessão); 4 min | Executado; sessão diária consumida |
| **Caso 3** | 3, 4, 7, 10, 13 | Free tenta acesso extra | Acesso bloqueado; oferta Premium |
| **Caso 4** | 1, 5, 7, 10, 13 | Premium sai em < 2 min | Saída permitida sem penalidade |
| **Caso 5** | 1, 6, 7, 10, 13 | Premium atinge 5 min | Sistema encerra automaticamente |
| **Caso 6** | 1, 4, 8, 10, 13 | Game com 3 interações | Game rejeitado do catálogo |
| **Caso 7** | 1, 4, 9, 10, 13 | Game com ação simultânea | Game rejeitado do catálogo |
| **Caso 8** | 1, 4, 7, 11, 13 | Game com pontuação | Game rejeitado por competitividade |
| **Caso 9** | 1, 4, 7, 12, 13 | Game com pressão temporal | Game rejeitado por pressão |
| **Caso 10**| 1, 4, 7, 10, 14 | Game exige internet | Bloqueado por quebra de regra offline |
| **Caso 11**| 1, 4, 7, 10, 15 | Game exige áudio | Bloqueado por impedir uso silencioso |

---

### 2.9 US-10 — Relatório Semanal/Mensal de Picos de Estresse

#### 🐛 Correção de Defeitos
*(Sem inspeção reportada. Os testes foram derivados diretamente da especificação validada do backlog).*

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Tipo de Plano | Premium (1) | Free (2) | Não autenticado (3) |
| Período do Filtro | Filtro 7 dias (4) | Filtro 14 dias (Free) (5) | Filtro 30 dias (Free) (6) |
| Qtde. Registros | $\ge$ 3 registros no período (7) | 1 ou 2 registros (8) | Nenhum registro (9) |
| Valor Termômetro | Entre 1 e 7 (sem pico) (10) | $\ge$ 8 (pico de estresse) (11) | Valor fora da escala (ex: 0) (12) |
| Exportação PDF | Premium solicita PDF (13) | Free solicita PDF (14) | Premium solicita sem registros (15) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 13 | Premium; 7 dias; 5 registros entre 1-7 | PDF gerado sem picos |
| **Caso 2** | 2, 4, 7, 10, 13 | Free; 7 dias; 4 registros | Relatório exibido; PDF com cadeado |
| **Caso 3** | 3, 4, 7, 10, 13 | Não autenticado tenta acesso | Acesso negado |
| **Caso 4** | 1, 5, 7, 10, 13 | Free; filtro de 14 dias | Conteúdo bloqueado; convite Premium |
| **Caso 5** | 1, 6, 7, 10, 13 | Free; filtro de 30 dias | Conteúdo bloqueado; convite Premium |
| **Caso 6** | 1, 4, 8, 10, 13 | Premium; 7 dias; apenas 2 registros | Relatório não gerado por falta de dados |
| **Caso 7** | 1, 4, 9, 10, 13 | Premium; 7 dias; 0 registros | Relatório não gerado |
| **Caso 8** | 1, 4, 7, 11, 13 | Premium; 7 dias; 1 registro com valor 9 | Relatório gerado; valor 9 destacado como pico |
| **Caso 9** | 1, 4, 7, 12, 13 | Premium; registro valor 0 | Rejeita valor fora de escala |
| **Caso 10**| 1, 4, 7, 10, 14 | Free tenta exportar PDF | Exportação bloqueada |
| **Caso 11**| 1, 4, 7, 10, 15 | Premium tenta PDF sem dados | Exportação indisponível |

---

### 2.10 US-11 — Perfil de Apoiador

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **18** | Omissão | 🟢 Corrigido | Faltava o fluxo de como se tornar apoiador. | Adicionamos envio de convite por e-mail com aceite formal. |
| **19** | Omissão | 🟢 Corrigido | Não detalhava o conteúdo da notificação. | O conteúdo agora se restringe ao nível de permissão autorizado. |
| **20** | Omissão | 🟢 Corrigido | Faltavam os "níveis de permissão". | Desenhamos 3 níveis (Só Crise, Humor Geral, Diário Completo). |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Validação do Convite | Convite válido (1) | E-mail inválido (2) | Link expirado (3) |
| Status do Vínculo | Convite aceito (4) | Convite pendente (5) | Convite recusado (6) |
| Nível de Permissão | Nível definido (7) | Sem permissão definida (8) | Permissão removida (9) |
| Conteúdo da Mensagem| Entre 1 e 500 caracteres (10) | Mensagem vazia (11) | > 500 caracteres (12) |
| Limite de Apoiadores | Até 5 ativos (13) | — | 6º apoiador (14) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 13 | Aceito, nível definido, 50 chars | Vínculo criado e mensagem enviada |
| **Caso 2** | 2, 4, 7, 10, 13 | E-mail inválido | Sistema rejeita envio de convite |
| **Caso 3** | 3, 4, 7, 10, 13 | Link acessado > 24h | Convite rejeitado por expiração |
| **Caso 4** | 1, 5, 7, 10, 13 | Convite pendente | Nenhum dado compartilhado |
| **Caso 5** | 1, 6, 7, 10, 13 | Convite recusado | Vínculo não estabelecido |
| **Caso 6** | 1, 4, 8, 10, 13 | Sem permissão definida | Sistema bloqueia o compartilhamento |
| **Caso 7** | 1, 4, 9, 10, 13 | Usuário remove o apoiador | Compartilhamento interrompido na hora |
| **Caso 8** | 1, 4, 7, 11, 13 | Mensagem vazia | Mensagem não enviada |
| **Caso 9** | 1, 4, 7, 12, 13 | Mensagem de 600 chars | Mensagem rejeitada |
| **Caso 10**| 1, 4, 7, 10, 14 | Tenta vincular o 6º | Sistema rejeita limite máximo |

---

### 2.11 US-12 — Emblemas Digitais

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **21** | Omissão | 🟢 Corrigido | Omitia exibição de emblemas pagos para contas gratuitas. | Aparecem bloqueados com cadeado, sem spoilers do desafio. |
| **22** | Ambiguidade | 🟢 Corrigido | O verbo "notifica" era vago. | Esclarecemos que a comemoração é apenas interna (modal), sem spam no SO. |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Autenticação | Autenticado (1) | Não autenticado (2) | Sessão expirada (3) |
| Status da Meta | Concluída (4) | Não concluída (5) | Meta inválida (6) |
| Disponibilidade | Emblema existente (7) | — | Emblema inexistente (8) |
| Histórico | Não conquistado (9) | Já conquistado (10) | — |
| Cadastro (BD) | Cadastro completo (11) | — | Cadastro incompleto (12) |
| Plano | Plano compatível (13) | — | Plano incompatível (Free) (14) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7, 9, 11, 13 | Autenticado; meta concluída; não conquistado | Emblema desbloqueado com sucesso |
| **Caso 2** | 2, 4, 7, 9, 11, 13 | Não autenticado | Operação negada |
| **Caso 3** | 3, 4, 7, 9, 11, 13 | Sessão expirada | Sistema solicita novo login |
| **Caso 4** | 1, 5, 7, 9, 11, 13 | Meta não concluída | Emblema não concedido |
| **Caso 5** | 1, 6, 7, 9, 11, 13 | Meta marcada inválida | Emblema não concedido |
| **Caso 6** | 1, 4, 8, 9, 11, 13 | Emblema inexistente | Rejeitado (Não encontrado) |
| **Caso 7** | 1, 4, 7, 10, 11, 13| Emblema já conquistado | Não concede novamente |
| **Caso 8** | 1, 4, 7, 9, 12, 13 | Emblema sem nome no BD | Emblema ocultado |
| **Caso 9** | 1, 4, 7, 9, 11, 14 | Usuário free em emblema premium| Cadeado exibido, meta oculta |

---

### 2.12 US-13 — Gamificação e Evolução do Pet

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **23** | Omissão | 🟢 Corrigido | "Itens visuais" impedia modelagem de BD. | Dividimos em: acessórios, planos de fundo e animações. |
| **24** | Omissão | 🟢 Corrigido | Faltava o XP matemático. | Fáceis = 10 XP, Difíceis = 20 XP. Evolução aos 100, 250 e 500 XP. |
| **25** | Ambiguidade | 🟢 Corrigido | Canal da "notificação" vago. | Usaremos modal *in-app* de celebração. |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Disponibilidade | Missão existente (1) | — | Missão inexistente (2) |
| Status da Missão | Primeira conclusão (3) | Já concluída hoje (4) | Expirada (5) |
| Conta | Conta válida (6) | — | Conta inválida (7) |
| Faixa de XP | Atinge mínimo (100, 250 ou 500) (8)| Abaixo do mínimo (9)| Acima do máximo (> 500) (10) |
| Limite Diário | Até 3 concluídas no dia (11)| — | 4ª missão no mesmo dia (12) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 6, 8, 11 | Missão concluída; XP chega a 100 | Pet evolui; 10 XP concedidos |
| **Caso 2** | 2, 3, 6, 8, 11 | Tenta missão inexistente | Operação rejeitada |
| **Caso 3** | 1, 4, 6, 8, 11 | Tenta repetir missão | XP não concedido |
| **Caso 4** | 1, 5, 6, 8, 11 | Missão expirada | Missão não pode ser concluída |
| **Caso 5** | 1, 3, 7, 8, 11 | Conta inválida | Acesso negado |
| **Caso 6** | 1, 3, 6, 9, 11 | Acumula 40 XP | Pet não evolui; XP guardado |
| **Caso 7** | 1, 3, 6, 10, 11| Acumula 520 XP | Não evolui mais; XP continua guardado |
| **Caso 8** | 1, 3, 6, 8, 12 | Tenta 4ª missão do dia | Bloqueia por limite diário atingido |

---

### 2.13 US-14 — Onboarding

#### 🐛 Correção de Defeitos
*(Sem inspeção reportada. Os testes foram derivados diretamente da especificação validada do backlog).*

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Tipo de Acesso | Primeiro acesso (1) | Acesso recorrente (2) | Usuário inválido (3) |
| Nome do Pet | Entre 1 e 20 caracteres (4) | Nome vazio (5) | Acima de 20 caracteres (6) |
| Orientação | Selecionado (7) | Não selecionado (8) | Valor inválido (9) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7 | Primeiro acesso, nome válido, estilo selecionado | Onboarding concluído com sucesso |
| **Caso 2** | 2, 4, 7 | Segundo acesso ao app | Onboarding não é exibido |
| **Caso 3** | 3, 4, 7 | Usuário inválido | Acesso negado |
| **Caso 4** | 1, 5, 7 | Primeiro acesso, nome vazio | Finalização bloqueada |
| **Caso 5** | 1, 6, 7 | Primeiro acesso, nome > 20 chars | Finalização bloqueada |
| **Caso 6** | 1, 4, 8 | Primeiro acesso, estilo não selecionado| Finalização bloqueada |
| **Caso 7** | 1, 4, 9 | Primeiro acesso, estilo inválido | Solicita nova seleção |

---

### 2.14 US-15 — Configuração de Notificações

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **26** | Omissão | 🟢 Corrigido | Bloqueio nativo do SO era ignorado. | O app detectará o bloqueio e exibirá um atalho para as configurações nativas. |
| **27** | Omissão | 🟢 Corrigido | Sem lista de tipos de lembrete. | Listamos 3: missões diárias, meditação e diário. |
| **28** | Omissão | 🟢 Corrigido | Faltava o gatilho de tempo. | Notificações de missões disparam sempre às 00h. |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Permissão (SO) | Permitida (1) | Negada (2) | Não definida (3) |
| Horário (HH:MM) | Formato válido (4) | Horário inválido (5) | Horário duplicado (6) |
| Status Interno | Ativada (7) | Desativada (8) | Configuração inconsistente (9) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 7 | Permissão concedida, 23:00, ativada | Notificação enviada |
| **Caso 2** | 2, 4, 7 | Permissão negada pelo SO | Aviso com atalho para o iOS/Android |
| **Caso 3** | 3, 4, 7 | Permissão não definida | Solicita definição prévia |
| **Caso 4** | 1, 5, 7 | Horário "25:80" | Configuração rejeitada |
| **Caso 5** | 1, 6, 7 | Horários iguais para mesmo tipo | Cadastro rejeitado |
| **Caso 6** | 1, 4, 8 | Horário válido, desativada | Nenhuma notificação enviada |
| **Caso 7** | 1, 4, 9 | Dados inconsistentes | Mantém última válida |

---

### 2.15 H16 — Autenticação de Usuário e Cadastro

#### 🐛 Correção de Defeitos
| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **29** | Omissão | 🟢 Corrigido | Regra de senha ignorava login social (Google). | O sistema dispensa senha e OTP se a conta for autenticada via Google. |
| **30** | Omissão | 🟢 Corrigido | Método de validar e-mail vago. | Inclusão de código OTP (6 números) com expiração de 15 minutos e botão de reenvio. |
| **31** | Fato Incorreto | 🟢 Corrigido | Duplicação na rastreabilidade (US-16). | Rebatizada oficialmente para **H16-2**. |

#### 🧪 Casos de Teste
| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Método Autenticação | Login Local (1) | Login Google OAuth (Dispensa OTP) (2) | — |
| Senha Local | $\ge$ 8 chars e contém número (3) | Sem números (4) | Menos de 8 chars (5) |
| Código OTP | Código correto e < 15 min (6) | Código incorreto (7) | Código expirado (8) |

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 6 | Login Local; Senha válida; OTP correto | Acesso e cadastro liberados |
| **Caso 2** | 2 | Login Google OAuth | Acesso liberado (ignora Senha e OTP) |
| **Caso 3** | 1, 4, 6 | Login Local; Senha: "SenhaSegura" | Bloqueio: Deve conter números |
| **Caso 4** | 1, 5, 6 | Login Local; Senha: "Abc1" | Bloqueio: Mínimo de 8 caracteres |
| **Caso 5** | 1, 3, 7 | Login Local; OTP: "000000" | Erro: Código inválido |
| **Caso 6** | 1, 3, 8 | Login Local; OTP expirou (>15m) | Erro: Código expirado, solicite novo |

---
<div align="center">
  <sub>Documentação final unificada para a disciplina de Engenharia de Software A - ICET/UFAM.</sub>
</div>
