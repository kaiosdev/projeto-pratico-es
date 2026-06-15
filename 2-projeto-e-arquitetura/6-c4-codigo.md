<div align="center">🏗️ DIAGRAMA DE CÓDIGO (ESTRUTURAL) C4: SLOW DOWN

Nível 4 — Diagrama de Classes UML

<img src="https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge" alt="Status"><br>Campo| Informação
Responsáveis| Nádia Leão
Projeto| SlowDown
Nível C4| Código / Estrutural (Nível 4)
Artefato| Diagrama de Classes UML
Status da Entrega| Concluído

</div>---

📖 1. OBJETIVO

O Diagrama de Código (Nível 4 do Modelo C4) representa a visão mais detalhada da arquitetura do sistema SlowDown, descrevendo a estrutura interna do domínio por meio de um Diagrama de Classes UML.

Neste nível são apresentados:

- As principais entidades do sistema;
- Os atributos e operações de cada classe;
- As regras de negócio encapsuladas nos modelos;
- Os relacionamentos e multiplicidades entre os objetos;
- A organização lógica do domínio da aplicação.

O objetivo deste artefato é demonstrar como os requisitos funcionais definidos no backlog foram traduzidos em uma estrutura de software consistente, escalável e alinhada aos princípios de orientação a objetos.

---

🖼️ 2. VISÃO GERAL DO DIAGRAMA

Figura 1 — Diagrama de Classes UML Completo

<div align="center"><img width="100%" alt="Diagrama de Código UML do SlowDown" src="https://github.com/user-attachments/assets/b30bb63f-f95b-48c4-84aa-9cfb4334ff97"/>Figura 1 — Diagrama de Classes UML completo do domínio do SlowDown.

</div>O diagrama apresenta a modelagem estrutural das principais funcionalidades do sistema, organizadas em módulos de domínio responsáveis por autenticação, monitoramento emocional, análise de estresse, gamificação, conteúdo de meditação, notificações e assistência conversacional.

A arquitetura evidencia a centralidade da entidade Usuário, que atua como ponto de integração entre os diferentes componentes do sistema.

---

🧩 3. VISÃO GERAL DOS MÓDULOS

Módulo| Responsabilidade
🔐 Autenticação| Cadastro, login e gerenciamento de sessões
👤 Perfil do Usuário| Preferências, acessibilidade e personalização
💳 Assinaturas| Controle de planos e recursos premium
😊 Bem-estar Emocional| Registro e acompanhamento emocional
❤️ Monitoramento Cardíaco| Coleta e análise de frequência cardíaca
📊 Inteligência Analítica| Geração de indicadores e relatórios
🎯 Gamificação| Missões, pet virtual e conquistas
🤖 Assistente Conversacional| Chatbot de apoio emocional
🎧 Conteúdo Guiado| Meditações e acompanhamento de sessões
🔔 Notificações| Alertas e lembretes personalizados

---

👤 4. USUÁRIO COMO CENTRO DO DOMÍNIO

A classe "Usuario" representa a principal entidade do sistema e funciona como agregadora dos demais módulos.

Através dela, o usuário pode:

- Gerenciar sua conta;
- Configurar preferências pessoais;
- Registrar estados emocionais;
- Acompanhar indicadores de bem-estar;
- Participar de missões;
- Evoluir seu pet virtual;
- Utilizar o chatbot;
- Consumir conteúdos de meditação;
- Receber notificações;
- Gerenciar sua assinatura.

A maioria das entidades do sistema possui relacionamento direto ou indireto com "Usuario", evidenciando seu papel central dentro da modelagem.

---

🔐 5. AUTENTICAÇÃO E CONTROLE DE ACESSO

O módulo de autenticação é composto pelas classes:

- "Usuario"
- "SessaoAutenticacao"
- "Assinatura"

Usuario

Responsável pela identidade digital do usuário.

Principais funcionalidades

- Cadastro tradicional;
- Cadastro via provedores externos;
- Recuperação de senha;
- Validação de credenciais;
- Ativação e desativação de conta.

SessaoAutenticacao

Responsável pelo gerenciamento das sessões ativas.

Funcionalidades

- Emissão de credenciais de acesso;
- Renovação de sessão;
- Revogação de acesso;
- Controle de expiração;
- Validação de sessão.

Assinatura

Responsável pelo gerenciamento dos planos disponíveis na plataforma.

Funcionalidades

- Confirmação de assinatura;
- Cancelamento;
- Verificação de acesso premium;
- Processamento de expiração;
- Integração com serviços de pagamento.

---

⚙️ 6. PERFIL E PERSONALIZAÇÃO

A classe "Perfil" concentra as preferências e configurações individuais do usuário.

Recursos disponíveis

- Configuração de estilo de orientação;
- Ajustes de acessibilidade;
- Controle de onboarding;
- Configurações de monitoramento;
- Personalização da experiência.

Estilos suportados

- Bíblico
- Psicológico
- Motivacional

Essas preferências influenciam diretamente a experiência do usuário dentro da aplicação.

---

😊 7. REGISTRO EMOCIONAL

O monitoramento emocional é realizado pela classe "RegistroEmocional".

Cada registro pode ser realizado utilizando diferentes métodos de entrada.

Métodos de registro

- Valor informado pelo usuário;
- Emoji;
- Cor;
- Outros formatos suportados pela aplicação.

Os registros são normalizados para uma escala padronizada utilizada pelas análises do sistema.

Principais funcionalidades

- Registro de humor;
- Atualização do estado emocional;
- Inclusão de observações;
- Sincronização em nuvem;
- Verificação de registros duplicados.

---

❤️ 8. MONITORAMENTO CARDÍACO

A classe "LeituraCardiaca" representa as leituras de frequência cardíaca capturadas pelo dispositivo.

Dados armazenados

- Valor da frequência cardíaca;
- Momento da coleta;
- Contexto da leitura;
- Estado de anomalia;
- Alertas disparados.

Funcionalidades

- Coleta contínua;
- Identificação de anomalias;
- Emissão de alertas;
- Geração de métricas de acompanhamento.

Esses dados são utilizados posteriormente para análises relacionadas ao bem-estar do usuário.

---

📊 9. INDICADORES E RELATÓRIOS

Indicador de Estresse

A classe "IndiceEstresse" consolida informações emocionais e fisiológicas registradas pela plataforma.

Fontes de informação

- Registros emocionais;
- Leituras cardíacas;
- Histórico de utilização;
- Indicadores monitorados pelo sistema.

O resultado permite:

- Detectar períodos críticos;
- Identificar padrões de comportamento;
- Apoiar recomendações futuras;
- Alimentar relatórios analíticos.

---

Relatórios

A classe "Relatorio" gera análises históricas da evolução do usuário.

Recursos

- Visualização de tendências;
- Exportação de relatórios;
- Recursos de acessibilidade;
- Histórico de eventos relevantes;
- Estatísticas consolidadas.

Os relatórios auxiliam o usuário no acompanhamento de sua evolução ao longo do tempo.

---

🎯 10. GAMIFICAÇÃO

O sistema utiliza técnicas de gamificação para incentivar hábitos saudáveis.

As principais entidades envolvidas são:

- "Missao"
- "Pet"
- "EmblemaDigital"

---

Missões

As missões representam desafios de autocuidado realizados pelo usuário.

Tipos

- Simples
- Avançada

Cada missão concluída contribui para a progressão do usuário dentro da plataforma.

---

Pet Virtual

O pet funciona como representação visual do progresso alcançado.

Características

- Evolução por estágios;
- Controle de felicidade;
- Personalização do nome;
- Impacto das interações do usuário.

A evolução do pet está diretamente relacionada ao engajamento do usuário.

---

Emblemas Digitais

Representam conquistas obtidas ao longo da jornada.

Categorias

- Básico
- Premium

Os emblemas são desbloqueados automaticamente quando determinadas metas são alcançadas.

---

🤖 11. ASSISTENTE CONVERSACIONAL

O módulo conversacional é composto pelas classes:

- "Conversa"
- "Mensagem"

Seu objetivo é oferecer apoio emocional e acompanhamento contínuo ao usuário.

Funcionalidades

- Histórico de conversas;
- Registro de mensagens;
- Personalização do estilo de orientação;
- Detecção de situações de risco;
- Acionamento de protocolos de apoio.

---

Detecção de Situações Críticas

A classe "Mensagem" possui mecanismos especializados para identificar sinais de vulnerabilidade emocional.

Entre eles:

- Correspondência de padrões;
- Análise de linguagem natural;
- Avaliação contextual;
- Identificação de gatilhos críticos.

Quando necessário, o sistema pode exibir recursos de apoio imediato.

---

🎧 12. MEDITAÇÃO 

Composto pelas classes:

- "Meditacao"
- "Locutor"
- "ProgressoSessao"

Recursos disponíveis

- Reprodução em segundo plano;
- Diferentes modalidades de conteúdo;
- Controle de progresso;
- Continuação de sessões interrompidas;
- Disponibilidade de recursos adicionais para usuários elegíveis.

Cada conteúdo pode ser associado a um locutor específico, permitindo personalização da experiência.

---

🔔 13. NOTIFICAÇÕES

A classe "Notificacao" gerencia os lembretes e interações automáticas do sistema.

Categorias

- Lembrete de prática;
- Missão diária;
- Evolução de progresso;
- Interações do sistema.

Funcionalidades

- Agendamento;
- Cancelamento;
- Agrupamento de notificações;
- Controle de envio.

Esses mecanismos auxiliam na manutenção do engajamento dos usuários.

---

🔗 14. PRINCIPAIS RELACIONAMENTOS

Os relacionamentos mais relevantes observados no diagrama são:

Origem| Destino| Cardinalidade
Usuario| Perfil| 1 : 1
Usuario| Assinatura| 1 : 1
Usuario| SessaoAutenticacao| 1 : N
Usuario| RegistroEmocional| 1 : N
Usuario| LeituraCardiaca| 1 : N
Usuario| Conversa| 1 : N
Usuario| Notificacao| 1 : N
Usuario| Relatorio| 1 : N
Usuario| Pet| 1 : 1
Usuario| Missao| N : N
Usuario| EmblemaDigital| N : N

Essas associações demonstram que a entidade "Usuario" atua como núcleo agregador de informações e comportamentos da plataforma.

---

✅ 15. CONCLUSÃO

O Diagrama de Classes UML do SlowDown apresenta uma modelagem abrangente e alinhada aos requisitos definidos para a aplicação.

A estrutura contempla funcionalidades de autenticação, monitoramento emocional, análise fisiológica, gamificação, suporte conversacional e consumo de conteúdo guiado, fornecendo uma base sólida para implementação, manutenção e evolução futura do sistema.

Além de representar a arquitetura interna do software, o diagrama também estabelece a rastreabilidade entre os requisitos de negócio e os componentes responsáveis por sua execução.

---

<div align="center"><sub>
Desenvolvido para a disciplina de Engenharia de Software A · ICET/UFAM<br>
Professor: Dr. Andrey Rodrigues
</sub></div>
