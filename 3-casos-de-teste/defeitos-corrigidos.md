<div align="center">

# 🛠️ Relatório de Inspeção e Correção de Defeitos — SlowDown

*Trabalho Prático III — Casos de Teste*



![Fase](https://img.shields.io/badge/Fase-Correção_de_Requisitos-4a90d9?style=for-the-badge&logo=github&logoColor=white)

</div>

## 1. Visão Geral da Inspeção

Este documento detalha o processo de **Correção dos Defeitos** identificados no Backlog do Produto do projeto SlowDown. A análise utilizou a taxonomia oficial de defeitos e manteve a rastreabilidade direta com as *issues* apontadas pela equipe auditora no GitHub.

### 1.1 Resumo Quantitativo
O projeto possui 19 Histórias de Usuário. A auditoria externa reportou exatamente **46 apontamentos**. 

| Origem | Status da Avaliação | Qtd | Descrição |
|:---|:---|:---:|:---|
| 🔍 **Auditoria** | 🟢 **Corrigidos** | **44** | Apontamentos externos válidos que resultaram em alteração no backlog. |
| 🔍 **Auditoria** | 🔴 **Falsos Positivos** | **2** | Apontamentos que não configuravam defeitos. Foram desconsiderados. |
| 🛡️ **Interno** | 🔵 **Auto-Auditoria** | **2** | Defeitos não apontados pela auditoria, mas que a própria equipe de desenvolvimento notou e reavaliou. |
| **TOTAL** | | **50** | *Geral de itens avaliados e tratados neste documento.* |

> 📌 **Aviso de Cobertura:** Das 19 Histórias de Usuário, as histórias **US-05 e US-14** não receberam nenhum apontamento de defeito da auditoria e não possuíam falhas internas aparentes. Portanto, estão estruturalmente corretas e não constam nas tabelas abaixo.

---

## 2. Detalhamento das Correções Implementadas

### US-01 — Sessões de Meditação Guiada
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **20** | Inconsistência entre contexto e Persona | 🔴 Falso Positivo | O trabalho rural possui pausas naturais. A semântica não afeta o sistema e foi mantida. |
| **21** | Ambiguidade de Controle de Sessão | 🟢 Corrigido | Deixamos claro que o aplicativo salva onde a pessoa parou, mas encerra a sessão após 2 horas. |
| **22** | Omissão de Configuração de Locutor | 🟢 Corrigido | Trocamos o termo vago para refletir a ação exata: "seleção do perfil de voz". |
| **37** | Inconsistência entre critério de aceitação e regra de negócio | 🟢 Corrigido | Ajuste direto das regras de plano Gratuito que entravam em conflito com o escopo pago. |
| **INT-01** | *(Auto-Auditoria)* Informação Estranha de Limites | 🔵 Interno | Identificamos e removemos detalhes sobre limites gratuitos listados indevidamente em uma US Premium. |

### US-02 — Playlists de Relaxamento Offline
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **17** | Inconsistência de Modelo de Negócio e Incompletude | 🟢 Corrigido | Adicionamos regras permitindo que o usuário apague ou troque a playlist a qualquer momento. |
| **18** | Omissão de Limites de Download Offline | 🟢 Corrigido | Inclusão de trava física: se o celular estiver cheio, o aplicativo interrompe o download. |
| **19** | Ambiguidade na funcionalidade "playlist relaxante" | 🔴 Falso Positivo | É apenas um filtro de pesquisa interna. O texto foi ajustado levemente para "curadoria", mas não era um defeito impeditivo. |
| **29** | Termo ambíguo em critério de aceitação | 🟢 Corrigido | Remoção de termos subjetivos sobre o comportamento contínuo da reprodução de áudio. |

### US-03 — Pet Virtual Inclusivo
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **16** | Inconsistência de Fluxo e Potencial Ambiguidade | 🟢 Corrigido | Criamos um "tempo de espera" de 7 dias para renomear o pet e exigimos suporte de voz/áudio nos botões. |

### US-04 — Monitoramento Cardíaco
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **14** | Ambiguidade de Configuração | 🟢 Corrigido | Definimos os alertas médicos exatos (entre 40 e 100 BPM), com possibilidade de personalização. |
| **15** | Ambiguidade de Atualização em Tempo Real | 🟢 Corrigido | Para evitar o descarregamento da bateria, alteramos para medições regulares no fundo do sistema. |
| **39** | Falta de clareza na definição de dispositivos compativeis | 🟢 Corrigido | Adicionada a regra exigindo o consentimento legal do usuário para acessar os sensores e dados de saúde do aparelho. |

### US-06 — Registro Emocional Diário
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **30** | Termo ambíguo em critério de aceitação | 🟢 Corrigido | A notificação "ao final do dia" foi fixada para as 20h00, configurável pelo usuário. |
| **31** | Inconsistência de Dados para Geração de Gráficos | 🟢 Corrigido | Centralizamos todas as regras de emoji, escala, cor e notas de texto nas tabelas do sistema. |
| **INT-02** | *(Auto-Auditoria)* Ambiguidade de Ator Genérico | 🔵 Interno | Identificamos o uso da palavra "usuário" e direcionamos a história diretamente para a Persona correta (Ana). |

### US-07 — Termômetro Emocional com Insights
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **33** | Omissão de Critérios de Personalização | 🟢 Corrigido | Detalhamos como o sistema vai ler a quantidade de registros da semana para gerar o conselho. |
| **35** | Ambiguidade de Parametrização | 🟢 Corrigido | Listamos explicitamente quais dados (idade, plano) o aplicativo utilizará para montar a sugestão. |

### US-08 — Chatbot Interativo com Incentivo Personalizado
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **36** | Ambiguidade de Conteúdo Sensível | 🟢 Corrigido | Definimos o acionamento automático de um protocolo de ajuda (telefone CVV 188) para relatos de crise e abuso. |
| **38** | Omissão quanto aos critérios que definem "sintomas graves" | 🟢 Corrigido | Adicionada uma regra que avalia palavras-chave e verifica se há mais de 7 dias de incapacidade registrados no aplicativo. |

### US-09 — Mini Games Antiestresse
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **32** | Inconsistência Lógica de Regra de Negócio | 🟢 Corrigido | Para não gerar estresse extra, removemos opções de ranking, placares ou contagem regressiva. |
| **34** | Ambiguidade de Complexidade dos Mini Games | 🟢 Corrigido | Limitamos a mecânica para jogos muito simples, com no máximo 2 comandos (como tocar e arrastar). |

### US-10 — Relatório Semanal/Mensal de Picos de Estresse
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **43** | Inconsistência entre os critérios de aceitação e as regras de negócio | 🟢 Corrigido | Ajustados os limites de geração do relatório para separar contas gratuitas de assinantes. |
| **44** | Omissão de Cálculo de Estresse | 🟢 Corrigido | Definido matematicamente que o pico de estresse é calculado por qualquer nota igual ou maior que 8. |
| **45** | Inconsistência entre Filtros e Permissões de Acesso | 🟢 Corrigido | Travamos os filtros avançados (14 e 30 dias) para serem exclusivos do plano Premium. |
| **46** | Ambiguidade de Métrica Emocional | 🟢 Corrigido | Padronizada a regra do termômetro de humor para atuar em uma escala numérica fixa de 1 a 10. |

### US-11 — Perfil de Apoiador
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **23** | Ambiguidade do Método de Vínculo | 🟢 Corrigido | Adicionado o envio de convite por e-mail, onde a pessoa de confiança precisa clicar para aceitar. |
| **24** | Omissão de Compartilhamento Emocional | 🟢 Corrigido | Limitamos o texto da notificação apenas às informações que o dono da conta autorizou. |
| **25** | Falta de detalhamento em regra de negócio | 🟢 Corrigido | Desenhamos 3 níveis claros de privacidade: Alerta de Crise, Humor Geral, e Leitura do diário. |

### US-12 — Emblemas Digitais
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **26** | Inconsistência de Regras de Bloqueio e Visualização | 🟢 Corrigido | Medalhas pagas agora aparecem na lista bloqueadas com o desenho de um cadeado. |
| **27** | Omissão de Critérios de Metas | 🟢 Corrigido | Especificamos que o emblema só é liberado após o usuário atingir as metas de saúde armazenadas no banco. |
| **28** | Termo ambíguo em critério de aceitação | 🟢 Corrigido | Esclarecemos que a comemoração é apenas uma mensagem na tela do aplicativo, sem apitar nas notificações do celular. |

### US-13 — Missões e Evolução do Pet
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **9** | Omissão de Itens Visuais Desbloqueáveis | 🟢 Corrigido | Separamos os prêmios do mascote em três categorias organizadas: acessórios, planos de fundo e animações. |
| **10** | Omissão de Progressão de XP | 🟢 Corrigido | Definidos valores fixos para as missões e evolução programada ao atingir 100, 250 e 500 pontos. |
| **11** | Termo ambíguo em critério de aceitação | 🟢 Corrigido | Especificada a exibição de uma janela de comemoração diretamente na tela do aplicativo. |

### US-15 — Configuração de Notificações
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **5** | Omissão de Fluxo de Exceção (Permissões de Sistema) | 🟢 Corrigido | O aplicativo perceberá se o usuário bloqueou notificações e exibirá um botão de atalho para as configurações do celular. |
| **6** | Omissão de Fluxo de Exceção (Permissões de Sistema) | 🟢 Corrigido | Apontamento duplicado pela auditoria, aproveitado para tratar o bloqueio independente do sistema (iOS ou Android). |
| **7** | Omissão de Tipos de Notificação | 🟢 Corrigido | Criamos 3 opções claras: lembrar missões, lembrar meditação e lembrar registro de humor. |
| **8** | Tempo do lembrete | 🟢 Corrigido | Definido que o sistema fará a limpeza automática das missões do dia sempre à meia-noite local. |

### US-16 — Autenticação de Usuário e Cadastro
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **12** | Omissão de Fluxo para Login Social (Google) | 🟢 Corrigido | O sistema deixará de pedir senha e código caso o usuário faça a autenticação diretamente pelo Google. |
| **13** | Validação e-mail | 🟢 Corrigido | O sistema enviará um código numérico de validação para o e-mail, que perde a validade em 15 minutos. |

### US-17 — Assinatura e Comparativo de Planos
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **41** | Ambiguidade no Gatilho de "Confirmação por E-mail" | 🟢 Corrigido | Reescrito para liberar o acesso pago e mandar o e-mail apenas após o sistema de pagamento do banco aprovar a transação. |
| **42** | Omissão de Fluxo de Assinatura | 🟢 Corrigido | O fluxo de pagamento agora pode ser iniciado de qualquer tela do aplicativo que exiba um recurso bloqueado. |

### US-18 — Sleepcasts e Histórias para Dormir
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **3** | Ambiguidade de Conteúdo Narrativo | 🟢 Corrigido | Regra explícita proibindo qualquer tipo de história que possua ação ou tensão que atrapalhe o sono. |
| **4** | Classificação por Duração | 🟢 Corrigido | Esclarecido que as opções de tempo funcionarão como botões de filtro (Curto e Longo) na tela de pesquisa. |

### US-19 — Modo Offline e Sincronização
| ID | Título do Apontamento Original | Status | Solução Implementada |
|:---:|:---|:---:|:---|
| **1** | Inconsistência de Regra de Negócio (Limites de Armazenamento) | 🟢 Corrigido | Fixado que apenas contas gratuitas terão a trava de limite de armazenamento interno aplicada. |
| **2** | Ambiguidade de Funcionalidades Essenciais | 🟢 Corrigido | Substituído por uma lista exata (apenas áudios baixados e diário) e bloqueio obrigatório das outras áreas. |
| **40** | Termo ambíguo em critério de aceitação | 🟢 Corrigido | Ficou definido que a sincronização do diário acontecerá de forma invisível no sistema assim que a rede de dados retornar. |

---

<div align="center">
  <sub> Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>
