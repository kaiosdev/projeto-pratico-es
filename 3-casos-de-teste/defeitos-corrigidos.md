<div align="center">

# 🛠️ Relatório de Correção de Defeitos — SlowDown

*Engenharia de Software A · ICET/UFAM*

![Fase](https://img.shields.io/badge/Fase-Inspeção_TP3-4a90d9?style=for-the-badge&logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Em_Andamento-ff9800?style=for-the-badge)

</div>

## 1. Visão Geral da Inspeção

Este documento detalha o processo de **Correção dos Defeitos** identificados durante a inspeção de requisitos do Trabalho Prático III. O objetivo é apresentar as análises realizadas, os problemas encontrados e as soluções implementadas para aprimorar a qualidade e a clareza das *User Stories* (US) do backlog do projeto.

> **Nota de Classificação:** As validações aplicadas neste relatório filtraram os falsos positivos e utilizaram rigorosamente a taxonomia oficial de defeitos de software (Omissão, Ambiguidade, Inconsistência, Fato Incorreto e Informação Estranha). 
> 
> ⚠️ **Status do Relatório:** Este é um documento vivo e encontra-se **em andamento**. Atualmente, reflete as correções parciais aplicadas ao backlog (11 de 18 User Stories inspecionadas).

### 1.1 Resumo Quantitativo (Parcial)

Até o presente momento da inspeção, as métricas de correção de defeitos para as **11 Histórias de Usuário** avaliadas são:

- **Total de Apontamentos Listados:** 31
- **🟢 Defeitos Corrigidos:** 29
- **🔴 Apontamentos Desconsiderados (Falsos Positivos):** 2

*(Estes números serão progressivamente atualizados à medida que as demais US forem inspecionadas e inseridas neste relatório).*

---

## 2. Detalhamento das Correções Implementadas

### 2.1 US 01 — Sessões de Meditação Guiada

O primeiro conjunto de correções focou na clareza e no contexto da funcionalidade de meditação guiada, garantindo o alinhamento exclusivo para a Persona Premium.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **1** | Inconsistência | 🔴 Falso Positivo | Conflito sugerido entre o ambiente rural da Persona e o termo "pausas de trabalho". | O trabalho rural possui pausas naturais. A semântica não afeta a arquitetura e foi mantida. |
| **2** | Ambiguidade | 🟢 Corrigido | A expressão "pausada a qualquer momento" não definia o estado de persistência do app. | Deixamos claro que o app salva onde a pessoa parou, mas se ela fechar o app ou sumir por 2 horas, a sessão expira. |
| **3** | Omissão | 🟢 Corrigido | O termo "locutor configuráveis" omitia quais parâmetros técnicos estariam disponíveis. | Trocamos o termo vago para refletir exatamente o que o usuário vai fazer: "seleção do perfil de voz". |
| **4** | Info. Estranha | 🟢 Corrigido | A regra original detalhava limites para contas *Free* em uma US exclusiva Premium. | Removemos essa regra, já que não faz sentido falar de limites gratuitos numa funcionalidade que é toda paga. |

### 2.2 US 02 — Playlists de Relaxamento Offline

Nesta etapa, as correções ajustaram as regras de download e introduziram requisitos não-funcionais sobre o gerenciamento de arquivos físicos no dispositivo.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **5** | Ambig. / Omissão | 🟢 Corrigido | A regra de "limite de 1 playlist" omitia o ciclo de vida do arquivo (exclusão e troca). | Adicionamos critérios permitindo que o usuário apague a playlist baixada a qualquer momento para liberar espaço ou trocar por outra. |
| **6** | Omissão | 🟢 Corrigido | O requisito não definia os limites relacionados ao armazenamento físico do dispositivo. | Colocamos uma trava: se o celular estiver cheio, o app vai interromper o download na hora e avisar que falta espaço. |
| **7** | Ambiguidade | 🔴 Falso Positivo | O termo "playlist relaxante" foi apontado como uma característica subjetiva e ambígua. | Isso é só uma tag no nosso banco de dados, então o sistema entende bem. Ajustamos levemente para "curadoria de relaxamento" só para ficar mais elegante. |

### 2.3 US 03 — Pet Virtual Inclusivo

As correções implementadas nesta User Story garantiram a inclusão de requisitos não-funcionais de acessibilidade e a manutenção da integridade das lógicas de engajamento.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **8** | Omissão / Ambig. | 🟢 Corrigido | Permitir renomear o pet "a qualquer momento" expunha o sistema a falhas de notificação e perda de métricas. | Criamos um "tempo de recarga" (cooldown). Agora o usuário precisa esperar 7 dias antes de poder trocar o nome do pet de novo. |
| **9** | Omissão | 🟢 Corrigido | O backlog destina a US à Persona de Acessibilidade, mas omitia o suporte a tecnologias assistivas. | Exigimos que todos os botões do pet tenham leitura em áudio (labels) e que dê para interagir usando o microfone do celular. |

### 2.4 US 04 — Monitoramento Cardíaco

Os ajustes focaram no desempenho da bateria de dispositivos móveis e na conformidade legal para o processamento de dados médicos.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **10** | Ambig. / Omissão | 🟢 Corrigido | Omitia os valores limite da "faixa saudável" e como o usuário faria essa configuração. | Definimos os alertas padrão da medicina (abaixo de 60 ou acima de 100 BPM), mas deixamos o usuário livre para personalizar isso nas configurações. |
| **11** | Ambiguidade | 🟢 Corrigido | O termo "em tempo real" não especificava a taxa de amostragem biométrica, o que drenaria a bateria. | Trocamos a leitura ininterrupta por verificações de segundo plano (ex: a cada 10 minutos) para poupar a bateria do celular. |
| **12** | Omissão | 🟢 Corrigido | O requisito omitia a obtenção do consentimento legal para o processamento de dados de saúde. | O app agora vai exigir um "aceito" do usuário nos termos da LGPD antes de guardar os dados de coração no sistema. |

### 2.5 US 06 — Registro Emocional Diário

Correções que eliminaram ambiguidades de horário e limpararam regras redundantes no texto da história.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **13** | Ambiguidade | 🟢 Corrigido | O critério dizia que a notificação chegaria "ao final do dia", um horário extremamente subjetivo. | Decidimos que o usuário é quem vai escolher o horário que prefere nas configurações, com as 20h00 como o padrão de fábrica. |
| **14** | Inconsistência | 🟢 Corrigido | A US possuía regras de negócio duplicadas e em texto livre soltas na descrição. | Limpamos o texto, retirando as informações duplicadas e centralizando tudo nas regras formais da tabela. |
| **15** | Ambiguidade | 🟢 Corrigido | A história usava o ator genérico "usuário", o que vai contra a nossa diferenciação de planos e perfis. | Trocamos o termo genérico e direcionamos a história exatamente para a nossa Persona correta, a Ana (Acessibilidade). |

### 2.6 US 07 — Insights Personalizados

Definição de lógicas de processamento e remoção de termos genéricos nas sugestões do sistema.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **16** | Omissão | 🟢 Corrigido | Falar em "insights personalizados" escondia como a lógica ou os algoritmos iam de fato funcionar. | Detalhamos exatamente como o sistema vai ler o histórico diário do usuário para conseguir gerar essas dicas úteis. |
| **17** | Ambiguidade | 🟢 Corrigido | O termo "preferências do usuário" permitia muitas interpretações diferentes para o time de desenvolvimento. | Mapeamos quais parâmetros do perfil (como idade e plano) o aplicativo realmente vai usar para montar as recomendações. |

### 2.7 US 11 — Perfil de Apoiador

Ajustes cruciais de segurança de dados e privacidade no momento de convidar alguém para monitorar o usuário.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **18** | Omissão | 🟢 Corrigido | O requisito não explicava de forma prática como uma pessoa se tornaria "apoiadora" de outra. | Adicionamos um fluxo de convite. O app manda um link por e-mail e o amigo tem que aceitar formalmente para o vínculo acontecer. |
| **19** | Omissão | 🟢 Corrigido | O texto não detalhava o que o apoiador ia poder ler nas notificações que recebesse sobre o usuário. | Amarramos o conteúdo da notificação para que ela mostre apenas o que o usuário dono da conta autorizou nas configurações. |
| **20** | Omissão | 🟢 Corrigido | O requisito dizia que existiam "níveis de permissão", mas esquecia de dizer quais eram esses níveis. | Desenhamos 3 níveis claros: 1 (só avisa em crise), 2 (mostra o humor geral) e 3 (mostra o humor e os textos do diário). |

### 2.8 US 12 — Emblemas Digitais

Refinamento sobre como exibir conteúdo premium para usuários gratuitos e como alertá-los dentro do app.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **21** | Omissão | 🟢 Corrigido | Não dizia como os emblemas exclusivos do plano pago iam aparecer para quem usa o aplicativo de graça. | Definimos que eles aparecem bloqueados com um cadeadinho e a frase "Disponível no Premium", sem dar spoilers do desafio. |
| **22** | Ambiguidade | 🟢 Corrigido | O verbo "notifica" não deixava claro se era um alerta de celular ou um pop-up interno. | Esclarecemos que a tela vai brilhar e comemorar apenas dentro do próprio aplicativo, sem encher o celular de notificações chatas. |

### 2.9 US 13 — Gamificação e Evolução do Pet

Estruturação das regras matemáticas de XP e especificação dos inventários cosméticos.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **23** | Omissão | 🟢 Corrigido | A palavra "itens visuais" era muito ampla e impedia o time de modelar o banco de dados do inventário. | Dividimos os itens em três grupos para organizar: acessórios para equipar, novos planos de fundo e animações de festa. |
| **24** | Omissão | 🟢 Corrigido | O requisito não trazia os números matemáticos (XP) que faziam o pet evoluir. | Colocamos números na mesa: missões fáceis dão 10 XP, difíceis dão 20 XP. O pet sobre de nível ao atingir 100, 250 e 500 XP. |
| **25** | Ambiguidade | 🟢 Corrigido | Assim como nos emblemas, o canal da "notificação" da evolução não estava estabelecido. | Fechamos a decisão de usar uma janela de comemoração saltando na tela (um modal in-app), sem alertas de sistema. |

### 2.10 US 15 — Notificações Personalizadas

Refatoração dos gatilhos de tempo e prevenção de erros nas permissões de celular.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **26** | Omissão | 🟢 Corrigido | O sistema não tratava o que aconteceria se o usuário ativasse o lembrete no app mas bloqueasse nas configurações do celular. | Se o celular estiver bloqueando, o app vai perceber, avisar a pessoa na hora e dar um atalho direto para ela consertar nas configurações. |
| **27** | Omissão | 🟢 Corrigido | Não havia uma lista com os tipos reais de lembretes que podiam ser ativados. | Listamos os três tipos oficiais de alertas: lembrar de fazer missões, lembrar de meditar e lembrar de registrar como foi o dia. |
| **28** | Omissão | 🟢 Corrigido | O momento exato (o gatilho do relógio) em que os alertas seriam disparados não existia no documento. | Para não ter erro no servidor, cravamos que as notificações de missões não feitas vão disparar sempre exatamente à meia-noite. |

### 2.11 H16-2 — Autenticação de Usuário e Cadastro

O refinamento desta etapa garantiu segurança na validação de usuários, integração com provedores externos e correções organizacionais da rastreabilidade.

| ID | Tipo de Defeito | Status | Descrição do Problema | Solução Implementada |
|:---:|:---|:---|:---|:---|
| **29** | Omissão | 🟢 Corrigido | A regra de senha complexa omitia o tratamento para o fluxo de login social (Google OAuth). | Configuramos o sistema para não cobrar a criação de uma senha interna nova se o usuário preferir entrar usando a conta do Google. |
| **30** | Omissão | 🟢 Corrigido | O termo "valida o e-mail" omitia o método técnico, tempo de expiração e o comportamento de reenvio. | Definimos as regras de segurança completas: vai usar um código de 6 números (OTP) que vence em 15 minutos e tem botão de enviar de novo. |
| **31** | Fato Incorreto | 🟢 Corrigido | Falha de gestão e duplicação de rastreabilidade (duas histórias diferentes cadastradas como US-16). | A história foi formalmente rebatizada e documentada como **H16-2**, acabando com a confusão de numeração no repositório. |

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>
