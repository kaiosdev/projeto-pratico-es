<div align="center">

# 🧪 Casos de Teste (Classes de Equivalência) — SlowDown

*Trabalho Prático III — Casos de Teste*


![Fase](https://img.shields.io/badge/Fase-Testes_de_Software-4a90d9?style=for-the-badge&logo=jest&logoColor=white)

</div>

## 1. Introdução

Este documento apresenta o Projeto de Casos de Teste Funcionais (Caixa Preta) para o escopo completo (US-01 à US-19) do Backlog do aplicativo SlowDown. 

Os testes foram construídos rigorosamente através da técnica de **Particionamento em Classes de Equivalência**, dividindo as entradas do sistema em *Classes Válidas* e *Classes Inválidas* para garantir uma cobertura sistemática das regras de negócio.

---

## 2. Casos de Teste por História de Usuário

### US-01 — Sessões de Meditação Guiada

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Duração da Sessão | Valor pertence ao conjunto: 5, 10, 15, 20 (1) | Valor fora do conjunto (2) | Valor nulo ou vazio (3) |
| Locutor | Locutor do catálogo selecionado (4) | Nenhum locutor selecionado (5) | — |
| Tipo de Assinatura | Usuário com plano Premium ativo (6) | Usuário com plano Gratuito (7) | Conta não autenticada (8) |

Classes de Equivalência da US-01.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4, 6 | Duração: 10; Locutor: Voz Serenidade; Plano: Premium | Sessão iniciada com sucesso |
| **Caso 2** | 2, 4, 6 | Duração: 7; Locutor: Voz Serenidade; Plano: Premium | Sistema impede início e exibe erro de duração |
| **Caso 3** | 3, 4, 6 | Duração: Nulo; Locutor: Voz Serenidade; Plano: Premium | Sistema impede início por campo obrigatório ausente |
| **Caso 4** | 1, 5, 6 | Duração: 10; Locutor: Nulo; Plano: Premium | Sistema solicita seleção obrigatória do locutor |
| **Caso 5** | 1, 4, 7 | Duração: 10; Locutor: Voz Serenidade; Plano: Gratuito | Sistema bloqueia acesso e exibe tela de assinatura |

Casos de Teste da US-01.

---

### US-02 — Playlists de Relaxamento Offline

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Espaço no Celular | Espaço livre $\ge$ tamanho do arquivo (1) | Espaço livre < tamanho do arquivo (2) | — |
| Conexão | Conectado à Internet (3) | Sem conexão / Modo Avião (4) | — |

Classes de Equivalência da US-02.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3 | Arquivo: 50MB; Espaço: 2000MB; Rede: Conectada | Download autorizado e playlist salva na seção Offline |
| **Caso 2** | 2, 3 | Arquivo: 50MB; Espaço: 10MB; Rede: Conectada | Download bloqueado e sistema alerta espaço insuficiente |
| **Caso 3** | 1, 4 | Arquivo: 50MB; Espaço: 2000MB; Rede: Offline | Sistema bloqueia tentativa e solicita conexão |

Casos de Teste da US-02.

---

### US-03 — Pet Virtual Inclusivo

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Tempo de espera | Tempo $\ge$ 7 dias (1) | Tempo < 7 dias (2) | — |
| Nome do Pet | Texto entre 1 e 20 caracteres (3) | Campo vazio (4) | Texto com mais de 20 caracteres (5) |
| Felicidade | Login em 48 horas ou menos (6) | Inatividade superior a 48 horas (7) | — |

Classes de Equivalência da US-03.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 6 | Tempo: 8 dias; Nome: Buddy; Inatividade: 24h | Nome alterado com sucesso e felicidade mantida |
| **Caso 2** | 2, 3, 6 | Tempo: 3 dias; Nome: Buddy; Inatividade: 24h | Sistema impede alteração e pede para aguardar os 7 dias |
| **Caso 3** | 1, 4, 6 | Tempo: 8 dias; Nome: Vazio; Inatividade: 24h | Sistema impede salvamento por campo em branco |
| **Caso 4** | 1, 5, 6 | Tempo: 8 dias; Nome: TextoLongo...; Inatividade: 24h | Sistema impede salvamento por limite de caracteres |
| **Caso 5** | 1, 3, 7 | Tempo: 8 dias; Nome: Buddy; Inatividade: 50h | Nome alterado, mas Pet perde 1 nível de felicidade |

Casos de Teste da US-03.

---

### US-04 — Monitoramento Cardíaco

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Frequência Cardíaca | Normal: Entre 40 e 100 BPM (1) | Abaixo de 40 BPM (Bradicardia) (2) | Acima de 100 BPM (Taquicardia) (3) |
| Tempo de Atualização| Tempo aceitável (ex: 10s) (4) | Muito curto (ex: 2s) (5) | Muito longo (ex: 90s) (6) |

Classes de Equivalência da US-04.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **CT01** | 1, 4 | BPM: 60; Intervalo: 10s | Aceito (Normal, sem alerta) |
| **CT02** | 1, 4 | BPM: 80; Intervalo: 10s | Aceito (Normal, sem alerta) |
| **CT03** | 3, 4 | BPM: 101; Intervalo: 10s | Aceito e gera alerta de taquicardia |
| **CT04** | 3, 4 | BPM: 120; Intervalo: 10s | Aceito e gera alerta de taquicardia |
| **EXTRA01** | 2, 4 | BPM: 35; Intervalo: 10s | Aceito e gera alerta de bradicardia |
| **EXTRA05** | 1, 5 | BPM: 60; Intervalo: 2s | Rejeitado (Intervalo muito curto) |
| **EXTRA06** | 1, 6 | BPM: 60; Intervalo: 90s | Rejeitado (Intervalo muito longo) |

Casos de Teste da US-04.

---

### US-05 — Navegação por Comandos de Voz

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Comando de Voz | Comando básico mapeado (ex: "abrir") (1) | Comando não mapeado/inexistente (2) | Áudio ininteligível ou silêncio (3) |
| Permissão do Mic | Concedida (4) | Negada (5) | — |

Classes de Equivalência da US-05.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4 | Comando: "abrir meditação"; Mic: Permitido | Toca som de confirmação e abre a tela solicitada |
| **Caso 2** | 2, 4 | Comando: "fritar batata"; Mic: Permitido | Não reconhece e avisa que o comando é inválido |
| **Caso 3** | 3, 4 | Comando: [Ruído]; Mic: Permitido | Sistema pede para o usuário repetir a frase |
| **Caso 4** | 1, 5 | Comando: "abrir meditação"; Mic: Negado | Bloqueia tentativa e solicita liberação do microfone |

Casos de Teste da US-05.

---

### US-06 — Registro Emocional Diário

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| ------------------- | ---------------- | ----------------- | ----------------- |
| Método de Registro do Humor | Emoji, cor ou escala numérica válidos (1) | Nenhum método selecionado (2) | Método não suportado pelo sistema (3) |
| Nota Textual | Texto com até 500 caracteres (4) | Texto com mais de 500 caracteres (5) | Dado incompatível com texto (6) |
| Registro Diário | Primeiro registro do dia (7) | Registro existente atualizado na mesma data (8) | Tentativa de criar mais de um registro na mesma data (9) |
| Horário da Notificação | Horário válido (padrão ou configurado) (10) | Horário inexistente (11) | Formato de horário inválido (12) |
| Sincronização dos Dados | Usuário Comum ou Premium com sincronização válida (13) | Usuário Premium sem conexão (14) | Falha na sincronização por dados inconsistentes (15) |

Classes de Equivalência da US-06.

| Caso | Classes | Entradas | Resultado Esperado |
| ---- | -------- | --------- | ------------------ |
| 1 | 1,4,7,10,13 | Método emoji válido, nota com 100 caracteres, primeiro registro do dia, horário padrão, usuário Premium com internet | Registro salvo com sucesso, normalizado para escala 1–10 e sincronizado |
| 2 | 2,4,7,10,13 | Nenhum método de registro selecionado | Sistema impede o registro e exibe mensagem de erro |
| 3 | 3,4,7,10,13 | Método de registro não suportado pelo sistema | Sistema rejeita o registro |
| 4 | 1,5,7,10,13 | Nota textual com mais de 500 caracteres | Sistema impede o salvamento e informa o limite permitido |
| 5 | 1,6,7,10,13 | Campo de nota contendo dado incompatível com texto | Sistema rejeita o registro |
| 6 | 1,4,8,10,13 | Usuário realiza novo registro na mesma data | Sistema informa a atualização e substitui o registro existente |
| 7 | 1,4,9,10,13 | Tentativa de criar um segundo registro no mesmo dia sem atualização | Sistema bloqueia a criação de um novo registro |
| 8 | 1,4,7,11,13 | Configuração de horário inexistente para notificação | Sistema rejeita a configuração |
| 9 | 1,4,7,12,13 | Configuração de horário em formato inválido | Sistema exibe erro de validação |
| 10 | 1,4,7,10,14 | Usuário Premium realiza registro sem conexão com a internet | Registro salvo localmente e sincronização adiada |
| 11 | 1,4,7,10,15 | Usuário Premium realiza registro com falha de sincronização causada por dados inconsistentes | Registro salvo localmente e sincronização rejeitada com registro de erro |

Casos de Teste da US-06.

---

### US-07 — Termômetro Emocional com Insights

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| ------------------- | ---------------- | ----------------- | ----------------- |
| Quantidade de registros emocionais na semana | Possui pelo menos 3 registros na semana (1) | Possui menos de 3 registros na semana (2) | Não possui registros na semana (3) |
| Perfil para geração de sugestões | Perfil completo com nível emocional, preferência e disponibilidade preenchidos (4) | Preferência de bem-estar não informada (5) | Disponibilidade de tempo não informada (6) |
| Tipo de usuário para acesso aos insights | Usuário Premium acessando insights avançados (7) | Usuário gratuito tentando acessar insights avançados (8) | Usuário sem identificação válida de plano (9) |
| Filtro do gráfico de evolução emocional | Filtro por semana ou mês (10) | Filtro inexistente (11) | Filtro não suportado pelo sistema (12) |
| Origem dos dados para geração dos insights | Dados registrados no próprio aplicativo (13) | Dados provenientes exclusivamente de terceiros (14) | Dados mistos contendo fontes externas não permitidas (15) |

Classes de Equivalência da US-07.

| Caso | Classes | Entradas | Resultado Esperado |
| ---- | -------- | --------- | ------------------ |
| 1 | 1,4,7,10,13 | Usuário com 5 registros na semana, perfil completo, plano Premium, filtro semanal e dados do aplicativo | Resumo semanal gerado com insights, sugestões e gráfico exibidos corretamente |
| 2 | 2,4,7,10,13 | Usuário com apenas 2 registros na semana | Sistema não gera o resumo e informa quantos registros ainda faltam |
| 3 | 3,4,7,10,13 | Usuário sem registros na semana | Sistema não gera o resumo e informa a ausência de registros suficientes |
| 4 | 1,5,7,10,13 | Usuário possui registros suficientes, mas não informou preferência de bem-estar | Sistema solicita o preenchimento da preferência antes de gerar sugestões |
| 5 | 1,6,7,10,13 | Usuário possui registros suficientes, mas não informou disponibilidade de tempo | Sistema solicita o preenchimento da disponibilidade antes de gerar sugestões |
| 6 | 1,4,8,10,13 | Usuário gratuito tenta acessar análise mensal comparativa ou histórico superior a 4 semanas | Sistema bloqueia o acesso e informa que o recurso é exclusivo para usuários Premium |
| 7 | 1,4,9,10,13 | Usuário tenta acessar insights avançados sem identificação válida do plano | Sistema impede o acesso aos insights avançados |
| 8 | 1,4,7,11,13 | Usuário seleciona um filtro inexistente para o gráfico | Sistema rejeita o filtro e exibe mensagem de erro |
| 9 | 1,4,7,12,13 | Usuário seleciona um filtro não suportado pelo sistema | Sistema rejeita a operação e solicita um filtro válido |
| 10 | 1,4,7,10,14 | Sistema recebe apenas dados provenientes de terceiros para geração dos insights | Sistema desconsidera os dados externos e não gera insights com essas informações |
| 11 | 1,4,7,10,15 | Sistema recebe dados do aplicativo misturados com fontes externas não permitidas | Sistema desconsidera os dados externos e gera os insights apenas com os dados válidos do aplicativo, ou bloqueia a geração caso não seja possível separar as fontes |

Casos de Teste da US-07.

---

### US-08 — Chatbot Interativo com Incentivo Personalizado

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| ------------------- | --------------- | ----------------- | ----------------- |
| Estilo de Orientação | Estilo selecionado entre as opções disponíveis: bíblico, psicológico ou motivacional (1) | Nenhum estilo selecionado (campo em branco) (2) | Estilo informado fora das opções disponíveis (ex.: "clínico", "espiritual") (3) |
| Conteúdo da Mensagem | Mensagem sobre bem-estar emocional sem indicadores de crise (ex.: "Estou me sentindo ansioso hoje") (4) | Mensagem vazia ou composta apenas por espaços em branco (5) | Mensagem contendo relato explícito de pensamento suicida ou de automutilação (6) |
| Indicadores de Crise | Nenhum indicador de crise presente na mensagem ou no histórico do usuário (7) | Presença de ao menos uma palavra-chave de crise aguda conforme lista clínica (8) | Histórico do termômetro emocional registra incapacidade de atividades básicas por mais de 7 dias consecutivos (9) |
| Acesso ao Histórico | Usuário autenticado acessa o próprio histórico de conversas (10) | Usuário não autenticado tenta acessar o histórico (11) | Usuário autenticado tenta acessar o histórico de outro usuário (12) |
| Conteúdo Sensível sem Crise Aguda | Relato de tristeza intensa sem indicadores de crise (ex.: "Estou muito triste, sem conseguir sair da cama") (13) | Relato de abuso físico, emocional ou sexual em curso (14) | Manifestação de crise de pânico ou dissociação em tempo real (15) |

Classes de Equivalência da US-08.

| Caso | Classes | Entradas | Resultado Esperado |
| ---- | ------- | -------- | ------------------ |
| 1 | 1,4,7,10,13 | Usuário autenticado acessa o próprio histórico; estilo "psicológico" selecionado; envia mensagem "Estou me sentindo ansioso hoje"; nenhum indicador de crise presente; relato de tristeza sem crise aguda ausente | Chatbot responde com tom psicológico, sugere conteúdos do aplicativo relacionados à ansiedade; conversa salva no histórico; aviso de que o chatbot não substitui atendimento profissional exibido na primeira interação |
| 2 | 2,4,7,10,13 | Usuário autenticado acessa o próprio histórico; nenhum estilo selecionado (campo em branco); envia mensagem válida sobre bem-estar; nenhum indicador de crise; conteúdo sensível sem crise aguda ausente | Sistema bloqueia o envio e solicita que o usuário selecione um estilo de orientação antes de prosseguir; chatbot não responde sem configuração definida |
| 3 | 3,4,7,10,13 | Usuário autenticado acessa o próprio histórico; estilo "clínico" informado (fora das opções disponíveis); envia mensagem válida sobre bem-estar; nenhum indicador de crise; conteúdo sensível sem crise aguda ausente | Sistema rejeita o estilo informado; mensagem de erro indica que apenas bíblico, psicológico ou motivacional são aceitos; chatbot não processa a mensagem |
| 4 | 1,5,7,10,13 | Usuário autenticado acessa o próprio histórico; estilo "motivacional" selecionado; tenta enviar mensagem vazia; nenhum indicador de crise; conteúdo sensível sem crise aguda ausente | Sistema bloqueia o envio; mensagem de erro informa que o campo de texto não pode estar vazio; histórico não é alterado |
| 5 | 1,6,7,10,13 | Usuário autenticado acessa o próprio histórico; estilo "bíblico" selecionado; envia mensagem com relato explícito de automutilação; nenhum indicador adicional de crise no histórico; conteúdo sensível sem crise aguda ausente | Protocolo de encaminhamento acionado: fluxo interrompido, mensagem de acolhimento clínica exibida, telefone CVV e opção de profissional apresentados; estilo substituído temporariamente pelo protocolo; evento registrado no histórico com marcação de alerta |
| 6 | 1,4,8,10,13 | Usuário autenticado acessa o próprio histórico; estilo "psicológico" selecionado; envia mensagem com palavra-chave de crise aguda da lista clínica; mensagem em si não contém relato explícito de automutilação; conteúdo sensível sem crise aguda ausente | Protocolo de encaminhamento acionado com base na palavra-chave clínica: fluxo interrompido, mensagem de acolhimento exibida, telefone CVV e profissional indicados; evento registrado com alerta no histórico |
| 7 | 1,4,9,10,13 | Usuário autenticado acessa o próprio histórico; estilo "motivacional" selecionado; envia mensagem válida sobre rotina; histórico do termômetro emocional registra incapacidade de atividades básicas por 8 dias consecutivos; conteúdo sensível sem crise aguda ausente | Protocolo de encaminhamento acionado com base no histórico: fluxo interrompido, mensagem de acolhimento exibida, telefone CVV e profissional indicados; estilo substituído temporariamente; evento registrado com alerta |
| 8 | 1,4,7,11,13 | Usuário não autenticado tenta acessar o histórico; estilo "bíblico" configurado na sessão; mensagem válida sobre bem-estar digitada; nenhum indicador de crise; conteúdo sensível sem crise aguda ausente | Acesso ao histórico negado; sistema redireciona para tela de autenticação; nenhum dado de conversa é exibido |
| 9 | 1,4,7,12,13 | Usuário autenticado (Usuário A) tenta acessar o histórico do Usuário B; estilo "psicológico" selecionado; mensagem válida sobre bem-estar enviada; nenhum indicador de crise; conteúdo sensível sem crise aguda ausente | Acesso negado; sistema retorna erro de permissão; nenhum dado do Usuário B é exibido ou compartilhado |
| 10 | 1,4,7,10,14 | Usuário autenticado acessa o próprio histórico; estilo "bíblico" selecionado; envia mensagem relatando abuso físico em curso; nenhum indicador adicional de crise aguda presente | Protocolo de encaminhamento acionado: fluxo interrompido, mensagem de acolhimento exibida, telefone CVV e profissional indicados; estilo substituído temporariamente pelo protocolo clínico; evento registrado com alerta no histórico |
| 11 | 1,4,7,10,15 | Usuário autenticado acessa o próprio histórico; estilo "psicológico" selecionado; envia manifestando crise de pânico em tempo real; nenhum indicador adicional de crise aguda presente | Protocolo de encaminhamento acionado: fluxo interrompido, mensagem de acolhimento exibida, telefone CVV e profissional indicados; estilo substituído temporariamente pelo protocolo clínico; evento registrado com alerta no histórico |

Casos de Teste da US-08.

---

### US-09 — Mini Games Antiestresse

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| ------------------- | --------------- | ----------------- | ----------------- |
| Tipo de Usuário | Usuário premium com acesso irrestrito a todos os mini games (1) | Usuário free dentro da janela de 24 horas com 1 sessão disponível (2) | Usuário free com sessão diária já encerrada (acesso bloqueado) (3) |
| Duração da Sessão | Sessão encerrada dentro do intervalo de 2 a 5 minutos (4) | Sessão encerrada antes de 2 minutos (5) | Sessão ultrapassando 5 minutos sem encerramento automático (6) |
| Tipo de Interação | Mini game utilizando até 2 tipos de interação distintos e sem combinações simultâneas (7) | Mini game utilizando mais de 2 tipos de interação (8) | Mini game exigindo combinação simultânea de comandos (9) |
| Elementos Competitivos | Mini game sem pontuação competitiva, ranking ou elementos de pressão de desempenho (10) | Mini game exibindo pontuação competitiva ou ranking (11) | Mini game exibindo elementos que geram pressão de desempenho no usuário (12) |
| Acessibilidade do Mini Game | Mini game funcionando sem conexão à internet e sem áudio obrigatório (13) | Mini game exigindo conexão à internet para funcionar (14) | Mini game exigindo áudio obrigatório, impedindo uso no modo silencioso (15) |

Classes de Equivalência da US-09.

| Caso | Classes | Entradas | Resultado Esperado |
| ---- | ------- | -------- | ------------------ |
| Caso 1 | 1,4,7,10,13 | Usuário premium acessa um mini game; sessão encerrada em 3 minutos; mini game utiliza toque e arrastar sem combinação simultânea; nenhum elemento competitivo exibido; dispositivo em modo silencioso e sem conexão à internet | Mini game executado com sucesso; sessão encerrada normalmente ao fim do tempo; nenhuma pontuação ou ranking exibido; funcionamento pleno sem áudio e sem internet |
| Caso 2 | 2,4,7,10,13 | Usuário free acessa o mini game dentro da janela de 24 horas (primeira sessão do dia); sessão encerrada em 4 minutos; mini game utiliza toque e segurar sem combinação simultânea; nenhum elemento competitivo exibido; dispositivo em modo silencioso e sem conexão à internet | Mini game executado com sucesso; sessão diária consumida; acesso bloqueado até a próxima janela de 24 horas; funcionamento pleno sem áudio e sem internet |
| Caso 3 | 3,4,7,10,13 | Usuário free tenta acessar mini game com sessão diária já encerrada; mini game utilizaria toque e arrastar; nenhum elemento competitivo; dispositivo em modo silencioso e sem conexão à internet | Acesso bloqueado; app exibe mensagem informando o tempo restante para liberação e oferece opção de upgrade para premium |
| Caso 4 | 1,5,7,10,13 | Usuário premium acessa um mini game; usuário encerra a sessão antes de 2 minutos sem penalidade; mini game utiliza toque e arrastar sem combinação simultânea; nenhum elemento competitivo; dispositivo em modo silencioso e sem internet | Saída imediata permitida sem penalidade; sessão encerrada normalmente; nenhum bloqueio ou punição aplicada ao usuário |
| Caso 5 | 1,6,7,10,13 | Usuário premium acessa um mini game; sessão atinge 5 minutos sem encerramento automático pelo sistema; mini game utiliza toque e segurar sem combinação simultânea; nenhum elemento competitivo; dispositivo em modo silencioso e sem internet | Sistema aciona encerramento automático ao atingir o limite de 5 minutos; sessão finalizada independentemente da ação do usuário |
| Caso 6 | 1,4,8,10,13 | Usuário premium acessa um mini game; sessão encerrada em 3 minutos; mini game utiliza toque, arrastar e segurar (3 tipos de interação); nenhum elemento competitivo; dispositivo em modo silencioso e sem internet | Mini game rejeitado do catálogo; sistema identifica uso de mais de 2 tipos de interação e impede a disponibilização do mini game |
| Caso 7 | 1,4,9,10,13 | Usuário premium acessa um mini game; sessão encerrada em 3 minutos; mini game exige toque e arrastar de forma simultânea e combinada; nenhum elemento competitivo; dispositivo em modo silencioso e sem internet | Mini game rejeitado do catálogo; sistema identifica combinação simultânea de comandos e impede a disponibilização do mini game |
| Caso 8 | 1,4,7,11,13 | Usuário premium acessa um mini game; sessão encerrada em 3 minutos; mini game utiliza toque e arrastar sem combinação simultânea; mini game exibe pontuação competitiva e ranking entre usuários; dispositivo em modo silencioso e sem internet | Mini game rejeitado do catálogo; sistema identifica presença de pontuação competitiva e ranking, vetando sua disponibilização |
| Caso 9 | 1,4,7,12,13 | Usuário premium acessa um mini game; sessão encerrada em 3 minutos; mini game utiliza toque e arrastar sem combinação simultânea; mini game exibe elementos que geram pressão de desempenho no usuário; dispositivo em modo silencioso e sem internet | Mini game rejeitado do catálogo; sistema identifica elementos de pressão de desempenho e impede sua disponibilização |
| Caso 10 | 1,4,7,10,14 | Usuário premium tenta acessar um mini game; sessão encerrada em 3 minutos; mini game utiliza toque e arrastar sem combinação simultânea; nenhum elemento competitivo; dispositivo sem conexão à internet e mini game exige internet para funcionar | Mini game não carrega; sistema exibe mensagem informando que o mini game não está disponível sem conexão; funcionalidade bloqueada |
| Caso 11 | 1,4,7,10,15 | Usuário premium acessa um mini game; sessão encerrada em 3 minutos; mini game utiliza toque e arrastar sem combinação simultânea; nenhum elemento competitivo; dispositivo em modo silencioso e mini game exige áudio obrigatório para funcionar | Mini game rejeitado do catálogo; sistema identifica dependência de áudio obrigatório, vetando sua disponibilização por impedir uso no modo silencioso |

Casos de Teste da US-09.

---

### US-10 — Relatório Semanal/Mensal de Picos de Estresse

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| ------------------- | --------------- | ----------------- | ----------------- |
| Tipo de Plano do Usuário | Usuário premium autenticado (1) | Usuário free autenticado (2) | Usuário não autenticado (3) |
| Período do Filtro | Filtro de 7 dias selecionado (4) | Filtro de 14 dias selecionado por usuário free (5) | Filtro de 30 dias selecionado por usuário free (6) |
| Quantidade de Registros no Período | 3 ou mais registros emocionais no período selecionado (7) | 1 ou 2 registros emocionais no período selecionado (8) | Nenhum registro emocional no período selecionado (9) |
| Valor do Registro no Termômetro | Registro com valor entre 1 e 7 na escala do termômetro (sem pico de estresse) (10) | Registro com valor igual ou superior a 8 na escala do termômetro (pico de estresse) (11) | Registro com valor fora da escala definida pelo termômetro (ex.: 0 ou 11) (12) |
| Exportação de Relatório em PDF | Usuário premium solicita exportação do relatório do período selecionado em PDF (13) | Usuário free tenta exportar o relatório em PDF (14) | Usuário premium tenta exportar relatório sem nenhum registro no período (15) |

Classes de Equivalência da US-10.

| Caso | Classes | Entradas | Resultado Esperado |
| ---- | ------- | -------- | ------------------ |
| 1 | 1,4,7,10,13 | Usuário premium autenticado; seleciona filtro de 7 dias; período contém 5 registros emocionais com valores entre 1 e 7; solicita exportação em PDF | Relatório gerado com gráfico de evolução emocional e destaque dos dias de maior estresse; exportação em PDF disponibilizada com sucesso; nenhum pico de estresse identificado |
| 2 | 2,4,7,10,13 | Usuário free autenticado; seleciona filtro de 7 dias; período contém 4 registros com valores entre 1 e 7; exportação em PDF não solicitada | Relatório semanal gerado e exibido normalmente; funcionalidades exclusivas premium exibidas com bloqueio visual (cadeado) |
| 3 | 3,4,7,10,13 | Usuário não autenticado tenta acessar o relatório emocional com filtro de 7 dias e 4 registros no período | Acesso negado; sistema redireciona para tela de autenticação; relatório não é exibido |
| 4 | 1,5,7,10,13 | Usuário free autenticado; seleciona filtro de 14 dias; período contém 4 registros com valores entre 1 e 7; exportação em PDF não solicitada | Sistema exibe tela de convite para upgrade ao plano premium; conteúdo do relatório de 14 dias não é exibido |
| 5 | 1,6,7,10,13 | Usuário free autenticado; seleciona filtro de 30 dias; período contém 6 registros com valores entre 1 e 7; exportação em PDF não solicitada | Sistema exibe tela de convite para upgrade ao plano premium; conteúdo do relatório de 30 dias não é exibido |
| 6 | 1,4,8,10,13 | Usuário premium autenticado; seleciona filtro de 7 dias; período contém apenas 2 registros emocionais com valores entre 1 e 7; solicita exportação em PDF | Relatório não é gerado; app exibe mensagem informando quantos registros ainda são necessários para atingir o mínimo de 3; exportação em PDF indisponível |
| 7 | 1,4,9,10,13 | Usuário premium autenticado; seleciona filtro de 7 dias; nenhum registro emocional no período; solicita exportação em PDF | Relatório não é gerado; app exibe mensagem informando que não há registros no período selecionado; exportação em PDF indisponível |
| 8 | 1,4,7,11,13 | Usuário premium autenticado; seleciona filtro de 7 dias; período contém 4 registros, sendo 1 com valor 9 (pico de estresse); solicita exportação em PDF | Relatório gerado; dia com valor 9 identificado como pico de estresse e destacado visualmente com data e valor correspondente; exportação em PDF disponibilizada com sucesso |
| 9 | 1,4,7,12,13 | Usuário premium autenticado; seleciona filtro de 7 dias; período contém registro com valor 0 (fora da escala do termômetro); solicita exportação em PDF | Sistema rejeita o registro inválido; valor fora da escala não é computado no relatório; app exibe mensagem de erro indicando que o valor está fora da escala definida pelo termômetro emocional |
| 10 | 1,4,7,10,14 | Usuário free autenticado; seleciona filtro de 7 dias; período contém 4 registros com valores entre 1 e 7; tenta exportar relatório em PDF | Exportação em PDF bloqueada; sistema exibe opção com cadeado e, ao ser acionada, apresenta tela de convite para upgrade ao plano premium |
| 11 | 1,4,7,10,15 | Usuário premium autenticado; seleciona filtro de 7 dias; nenhum registro emocional no período; tenta exportar relatório em PDF | Exportação em PDF indisponível; app exibe mensagem informando que não há registros no período selecionado para gerar o arquivo |

Casos de Teste da US-10.

---

### US-11 — Perfil de Apoiador

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
|---|---|---|---|
| Validação do Convite | Convite válido (1) | E-mail inválido (2) | Link expirado (3) |
| Status do Vínculo | Convite aceito (4) | Convite pendente (5) | Convite recusado (6) |
| Nível de Compartilhamento | Nível definido (7) | Sem permissão definida (8) | Permissão removida (9) |
| Conteúdo da Mensagem | Entre 1 e 500 caracteres (10) | Mensagem vazia (11) | Acima de 500 caracteres (12) |
| Limite de Apoiadores | Até 5 ativos (13) | — | 6º apoiador (14) |

Classes de Equivalência da US-11.

| Caso | Classes | Entradas | Resultado Esperado |
|---|---|---|---|
| 1 | 1,4,7,10,13 | Convite válido, aceito, permissão definida, mensagem de 50 caracteres, 3º apoiador | Vínculo criado e mensagem enviada com sucesso |
| 2 | **2**,4,7,10,13 | E-mail digitado de forma inválida no convite | Sistema rejeita o envio do convite |
| 3 | **3**,4,7,10,13 | Link de convite utilizado após 24 horas | Convite rejeitado por expiração |
| 4 | 1,**5**,7,10,13 | Convite enviado, convidado ainda não respondeu | Nenhum dado é compartilhado |
| 5 | 1,**6**,7,10,13 | Convite enviado, convidado recusa o vínculo | Vínculo não estabelecido |
| 6 | 1,4,**8**,10,13 | Vínculo aceito, mas sem nível de permissão definido | Sistema bloqueia o compartilhamento |
| 7 | 1,4,**9**,10,13 | Vínculo ativo, usuário remove o apoiador | Compartilhamento interrompido imediatamente |
| 8 | 1,4,7,**11**,13 | Vínculo ativo, mensagem de encorajamento vazia | Mensagem não enviada |
| 9 | 1,4,7,**12**,13 | Vínculo ativo, mensagem com 600 caracteres | Mensagem rejeitada |
| 10 | 1,4,7,10,**14** | Usuário tenta vincular o 6º apoiador | Sistema rejeita (limite de 5 atingido) |

Casos de Teste da US-11.

---

### US-12 — Emblemas Digitais

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
|---|---|---|---|
| Autenticação do Usuário | Autenticado (1) | Não autenticado (2) | Sessão expirada (3) |
| Status da Meta | Concluída (4) | Não concluída (5) | Meta inválida (6) |
| Disponibilidade do Emblema | Emblema existente (7) | — | Emblema inexistente (8) |
| Histórico de Conquista | Não conquistado (9) | Já conquistado (10) | — |
| Cadastro do Emblema | Cadastro completo (11) | — | Cadastro incompleto (12) |
| Compatibilidade do Plano | Plano compatível (13) | — | Plano incompatível (14) |

Classes de Equivalência da US-12.

| Caso | Classes | Entradas | Resultado Esperado |
|---|---|---|---|
| 1 | 1,4,7,9,11,13 | Usuário autenticado conclui meta de emblema compatível com seu plano | Emblema desbloqueado com sucesso |
| 2 | **2**,4,7,9,11,13 | Usuário não autenticado tenta acessar emblemas | Operação negada |
| 3 | **3**,4,7,9,11,13 | Sessão expirada durante consulta de emblemas | Sistema solicita novo login |
| 4 | 1,**5**,7,9,11,13 | Meta ainda não concluída | Emblema não concedido |
| 5 | 1,**6**,7,9,11,13 | Meta marcada como inválida no sistema | Emblema não concedido, erro registrado |
| 6 | 1,4,**8**,9,11,13 | Emblema referenciado não existe na base de dados | Operação rejeitada (erro: não encontrado) |
| 7 | 1,4,7,**10**,11,13 | Emblema já conquistado anteriormente | Sistema não concede novamente |
| 8 | 1,4,7,9,**12**,13 | Emblema cadastrado sem nome ou descrição | Emblema não exibido, erro reportado |
| 9 | 1,4,7,9,11,**14** | Usuário gratuito tenta desbloquear emblema exclusivo premium | Cadeado exibido, meta oculta |

Casos de Teste da US-12.

---

### US-13 — Missões e Evolução do Pet

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
|---|---|---|---|
| Disponibilidade da Missão | Missão existente (1) | — | Missão inexistente (2) |
| Status da Missão | Primeira conclusão do dia (3) | Já concluída hoje (4) | Expirada (5) |
| Situação da Conta | Conta válida (6) | — | Conta inválida (7) |
| Faixa de XP | Atinge o XP mínimo — 100, 250 ou 500 (8) | Abaixo do mínimo — ex: 40, 90 XP (9) | Acima do nível máximo — acima de 500 (10) |
| Limite de Missões Diárias | Até 3 concluídas no dia (11) | — | 4ª missão no mesmo dia (12) |

Classes de Equivalência da US-13.

| Caso | Classes | Entradas | Resultado Esperado |
|---|---|---|---|
| 1 | 1,3,6,8,11 | Missão existente, primeira conclusão do dia, conta válida, XP chega a 100, dentro do limite | Pet evolui para o nível 2, 10 XP concedidos |
| 2 | **2**,3,6,8,11 | Usuário tenta concluir missão que não existe mais no sistema | Operação rejeitada |
| 3 | 1,**4**,6,8,11 | Missão já concluída hoje, tentativa de repetir | XP não concedido |
| 4 | 1,**5**,6,8,11 | Missão expirada após renovação diária | Missão não pode ser concluída |
| 5 | 1,3,**7**,8,11 | Usuário com conta inválida tenta concluir missão | Acesso negado |
| 6 | 1,3,6,**9**,11 | Usuário acumula 40 XP (abaixo do próximo marco de 100) | Pet não evolui, permanece no nível atual |
| 7 | 1,3,6,**10**,11 | Usuário acumula 520 XP (acima de 500) | Nenhuma evolução adicional, XP continua acumulando |
| 8 | 1,3,6,8,**12** | Usuário gratuito tenta concluir a 4ª missão do dia (já completou 3) | Sistema bloqueia, exibe aviso de limite diário atingido |

Casos de Teste da US-13.

---

### US-14 — Onboarding

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
|---|---|---|---|
| Tipo de Acesso | Primeiro acesso (1) | Acesso recorrente (2) | Usuário inválido (3) |
| Nome do Pet | Entre 1 e 20 caracteres (4) | Nome vazio (5) | Acima de 20 caracteres (6) |
| Preferência de Orientação | Selecionado (7) | Não selecionado (8) | Valor inválido (9) |

Classes de Equivalência da US-14.

| Caso | Classes | Entradas | Resultado Esperado |
|---|---|---|---|
| 1 | 1,4,7 | Primeiro acesso, nome válido, estilo de orientação selecionado | Onboarding concluído com sucesso, usuário direcionado à tela principal |
| 2 | **2**,4,7 | Segundo acesso ao app | Onboarding não é exibido |
| 3 | **3**,4,7 | Usuário inválido tenta iniciar onboarding | Acesso negado |
| 4 | 1,**5**,7 | Primeiro acesso, nome do pet vazio | Finalização bloqueada |
| 5 | 1,**6**,7 | Primeiro acesso, nome do pet acima de 20 caracteres | Finalização bloqueada |
| 6 | 1,4,**8** | Primeiro acesso, nome válido, estilo de orientação não selecionado | Finalização bloqueada |
| 7 | 1,4,**9** | Primeiro acesso, nome válido, valor inválido enviado para o estilo de orientação | Sistema rejeita e solicita nova seleção |

Casos de Teste da US-14.

---

### US-15 — Configuração de Notificações

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
|---|---|---|---|
| Permissão de Notificações | Permitida (1) | Negada (2) | Não definida (3) |
| Validação do Horário | Formato HH:MM válido (4) | Horário inválido (5) | Horário duplicado (6) |
| Status da Notificação | Ativada (7) | Desativada (8) | Configuração inconsistente (9) |

Classes de Equivalência da US-15.

| Caso | Classes | Entradas | Resultado Esperado |
|---|---|---|---|
| 1 | 1,4,7 | Permissão concedida, horário 23:00 válido, notificação ativada | Notificação enviada com sucesso |
| 2 | **2**,4,7 | Permissão negada pelo sistema operacional | Aviso exibido ao usuário, com atalho para configurações |
| 3 | **3**,4,7 | Permissão ainda não definida pelo usuário | Sistema solicita definição antes de configurar notificações |
| 4 | 1,**5**,7 | Permissão concedida, horário configurado como "25:80" | Configuração rejeitada |
| 5 | 1,**6**,7 | Permissão concedida, dois horários iguais cadastrados para o mesmo tipo de notificação | Cadastro rejeitado |
| 6 | 1,4,**8** | Permissão concedida, horário válido, notificação desativada pelo usuário | Nenhuma notificação enviada |
| 7 | 1,4,**9** | Permissão concedida, horário válido, configuração salva com dados inconsistentes | Sistema rejeita, mantém última configuração válida |

Casos de Teste da US-15.

---

### US-16 (H16-2) — Autenticação de Cadastro (Sincronizado com Código)

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Endereço de E-mail | Com @ e domínio correto (1) | E-mail sem @ (2) | E-mail sem domínio (ex: `.com`) (3) |
| Criação da Senha | Letras, números e min. 6 chars (4) | Senha sem usar números (5) | Senha menor que 6 caracteres (6) |
| Código Recebido | Código exato e não expirado (7) | Código expirado (passou 15m) (8) | Digitou código errado (9) |

Classes de Equivalência da US-16.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **CT01** | 1, 4, 7 | E-mail: `user@gmail.com` ; Senha válida ; Código certo | Aceito e cadastro concluído |
| **CT02** | 2, 4, 7 | E-mail: `usergmail.com` | Rejeitado (Falta o @) |
| **CT03** | 1, 4, 7 | Senha: `Carlos123` | Aceita (Possui letras, números e tamanho correto) |
| **CT04** | 1, 5, 7 | Senha: `abcdefgh` | Rejeitada (Senha não possui números) |
| **CT06** | 1, 4, 8 | Código recebido há 16 minutos | Rejeitado (Código passou da validade) |
| **EXTRA01**| 3, 4, 7 | E-mail: `user@` | Rejeitado (Sem domínio) |
| **EXTRA03**| 1, 6, 7 | Senha: `Ab1` | Rejeitada (Senha com apenas 3 caracteres) |
| **EXTRA05**| 1, 4, 9 | Digita "000000" em vez do número correto | Rejeitado (Código inválido) |

Casos de Teste da US-16.

---

### US-17 — Assinatura e Comparativo de Planos

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Status do Pagamento | Cartão aprovado com sucesso (1) | Cartão recusado / sem limite (2) | Pagamento em análise (3) |
| Tempo de Vigência | Fez a compra agora ou já tem (4) | Já venceu (passou de 30 dias) (5) | Cancelou hoje (ainda tem dias sobrando) (6) |

Classes de Equivalência da US-17.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 4 | Sistema do cartão retorna OK | Libera todas as funções e remove cadeados na hora |
| **Caso 2** | 2, 4 | Sistema do cartão retorna RECUSADO | Exibe "Falha no pagamento", não libera nada e não manda e-mail |
| **Caso 3** | 3, 4 | Sistema do cartão diz EM ANÁLISE | Deixa a conta gratuita até o dinheiro cair na conta |
| **Caso 4** | 1, 6 | Assinou dia 01 e cancelou dia 15 | Exibe mensagem dizendo que continuará VIP até o dia 30, de graça |
| **Caso 5** | 1, 5 | Passou o dia 30 e a pessoa cancelou antes | O app tira a conta VIP e devolve os cadeados nas funções |

Casos de Teste da US-17.

---

### US-18 — Sleepcasts e Histórias para Dormir

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Quantidade Trocada | Gratuito tocando 1ª ou 2ª música (1) | Gratuito tentando a 3ª música (2) | — |
| Relógio de Fechar | Temporizador marcado 30 min (3) | Temporizador quebrado/negativo (4) | — |
| Foco no Celular | App minimizado / Celular apagado (5) | Fechou o aplicativo totalmente (6) | — |

Classes de Equivalência da US-18.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 5 | Gratuito; Marca 30 min e apaga a tela | A música roda por meia hora e o app silencia sozinho para a pessoa dormir |
| **Caso 2** | 2, 3, 5 | Gratuito tenta a 3ª música | Bloqueia a música e manda uma tela de assinatura |
| **Caso 3** | 1, 4, 5 | Marca -10 minutos | Rejeita na hora e volta pro padrão |
| **Caso 4** | 1, 3, 6 | Ouve 5 minutos e fecha o app removendo-o da memória | O áudio é cortado abruptamente na mesma hora |

Casos de Teste da US-18.

---

### US-19 — Modo Offline e Sincronização

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Situação da Rede | Sem Wi-Fi / Sem Dados 4G (1) | Wi-Fi retornou (2) | — |
| Onde vai clicar | Toca áudio que já está salvo (3) | Toca áudio que não baixou (4) | Tenta abrir a IA do Chatbot (5) |
| Digitação de Dados | Preenche o Diário Emocional (6) | Tenta compartilhar link com amigo (7) | — |

Classes de Equivalência da US-19.

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3 | Sem rede; Clica na música que baixou em casa | Toca imediatamente |
| **Caso 2** | 1, 4 | Sem rede; Clica numa meditação com nuvem | Dá erro avisando que precisa baixar primeiro |
| **Caso 3** | 1, 5 | Sem rede; Tenta conversar com o robô (IA) | Bloqueia a tela e avisa "Conecte-se para usar a Inteligência Artificial" |
| **Caso 4** | 1, 6 | Sem rede; Escreve "estou triste" no diário | Salva na memória do celular e guarda |
| **Caso 5** | 2, 6 | Wi-Fi retornou | O aplicativo pega o diário escondido e sobe automaticamente para o servidor central sem a pessoa precisar clicar |

Casos de Teste da US-19.

---

<div align="center">
  <sub> Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues </sub>
</div>