<div align="center">

# 🏗️ DIAGRAMA DE CÓDIGO (ESTRUTURAL) C4: SLOW DOWN
*Nível 4 — Diagrama de Classes UML — Engenharia de Software A*

<img src="https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge" alt="Status">

<br><br>

| Campo | Informação |
|:---|:---|
| **Responsáveis** | Nádia Leão |
| **Projeto** | SlowDown |
| **Nível C4** | Código / Estrutural (Nível 4) |
| **Artefato** | Diagrama de Classes UML |
| **Status da Entrega** | Concluído |

</div>


## 📖 1. OBJETIVO

O Diagrama de Código (Nível 4 do Modelo C4) representa a visão mais detalhada da arquitetura do sistema SlowDown, descrevendo a estrutura interna do domínio por meio de um Diagrama de Classes UML.

Neste nível são apresentados:
*   As principais entidades do sistema;
*   Os atributos e operações de cada classe;
*   As regras de negócio encapsuladas nos modelos;
*   Os relacionamentos e multiplicidades entre os objetos;
*   A organização lógica do domínio da aplicação.

O objetivo deste artefato é demonstrar como os requisitos funcionais definidos no backlog foram traduzidos em uma estrutura de software consistente, escalável e alinhada aos princípios de orientação a objetos.


## 🖼️ 2. VISÃO GERAL DO DIAGRAMA

O diagrama apresenta a modelagem estrutural das principais funcionalidades do sistema, organizadas em módulos de domínio responsáveis por autenticação, monitoramento emocional, análise de estresse, gamificação, conteúdo de meditação, notificações e assistência conversacional. A arquitetura evidencia a centralidade da entidade `Usuario`.

<div align="center">
   <img width="100%" alt="Diagrama sem nome-Diagrama de código  (2)" src="https://github.com/user-attachments/assets/fba3679d-b2be-4397-9943-edd86d9c0293" />
  <p><i><b>Figura 1:</b> Diagrama de Classes UML completo do domínio do SlowDown.</i></p>
</div>


## 🧩 3. VISÃO GERAL DOS MÓDULOS

| Módulo | Responsabilidade |
|:---|:---|
| **🔐 Autenticação** | Cadastro, login e gerenciamento de sessões |
| **👤 Perfil do Usuário** | Preferências, acessibilidade e personalização |
| **💳 Assinaturas** | Controle de planos e recursos premium |
| **😊 Bem-estar Emocional** | Registro e acompanhamento emocional |
| **❤️ Monitoramento Cardíaco** | Coleta e análise de frequência cardíaca |
| **📊 Inteligência Analítica** | Geração de indicadores e relatórios |
| **🎯 Gamificação** | Missões, pet virtual e conquistas |
| **🤖 Assistente Conversacional** | Chatbot de apoio emocional |
| **🎧 Conteúdo Guiado** | Meditações e acompanhamento de sessões |
| **🔔 Notificações** | Alertas e lembretes personalizados |


## 👤 4. USUÁRIO COMO CENTRO DO DOMÍNIO

A classe `Usuario` representa a principal entidade do sistema e funciona como agregadora dos demais módulos. A maioria das entidades do sistema possui relacionamento direto ou indireto com `Usuario`, evidenciando seu papel central dentro da modelagem. Através dela, o usuário pode:
*   Gerenciar sua conta e assinatura;
*   Configurar preferências pessoais;
*   Registrar estados emocionais e acompanhar indicadores;
*   Participar de missões e evoluir seu pet virtual;
*   Utilizar o chatbot e consumir conteúdos de meditação.


## 🔐 5. AUTENTICAÇÃO E CONTROLE DE ACESSO

O módulo de autenticação e acesso é composto pelas classes:
*   **`Usuario`:** Responsável pela identidade digital, contemplando cadastro, validação de credenciais e controle de conta.
*   **`SessaoAutenticacao`:** Gerencia as sessões ativas, emissão de credenciais de acesso, controle de expiração e revogação.
*   **`Assinatura`:** Gerencia os planos da plataforma, processamento de expiração e verificação de acesso premium.

## ⚙️ 6. PERFIL E PERSONALIZAÇÃO

A classe `Perfil` concentra as preferências e configurações individuais do usuário, influenciando diretamente sua experiência na aplicação.
*   **Recursos:** Ajustes de acessibilidade, controle de onboarding e configurações de monitoramento.
*   **Estilos de Orientação Suportados:** Bíblico, Psicológico e Motivacional.


## 😊 7. REGISTRO EMOCIONAL

O monitoramento diário é realizado pela classe `RegistroEmocional`. Os registros são normalizados para uma escala padronizada utilizada pelas análises do sistema.
*   **Métodos de registro:** Valor numérico, Emoji ou Cor.
*   **Funcionalidades:** Inclusão de observações, sincronização em nuvem e verificação de duplicidade.


## ❤️ 8. MONITORAMENTO CARDÍACO

A classe `LeituraCardiaca` representa as leituras capturadas pelo dispositivo, dados que alimentam análises posteriores.
*   **Armazenamento:** Valor da frequência (BPM), momento da coleta, contexto e estado de anomalia.
*   **Funcionalidades:** Coleta contínua, identificação de picos e emissão de alertas.


## 📊 9. INDICADORES E RELATÓRIOS

*   **`IndiceEstresse`:** Consolida informações subjetivas (registros) e fisiológicas (leituras cardíacas) para detectar períodos críticos, identificar padrões e alimentar relatórios.
*   **`Relatorio`:** Gera análises históricas da evolução do usuário, com estatísticas consolidadas e exportação de dados.


## 🎯 10. GAMIFICAÇÃO

Técnicas utilizadas para incentivar hábitos saudáveis:
*   **`Missao`:** Desafios de autocuidado (Simples ou Avançada) que geram progressão.
*   **`Pet`:** Representação visual do progresso. Evolui por estágios, tem controle de felicidade e é impactado pelo engajamento do usuário.
*   **`EmblemaDigital`:** Conquistas (Básico ou Premium) desbloqueadas automaticamente ao bater metas.


## 🤖 11. ASSISTENTE CONVERSACIONAL

Composto pelas classes `Conversa` e `Mensagem`, oferece apoio emocional contínuo.
*   **Funcionalidades:** Histórico, personalização do estilo de orientação e acionamento de protocolos.
*   **Detecção Crítica:** A classe `Mensagem` analisa padrões e contextos para identificar gatilhos de vulnerabilidade, oferecendo recursos de apoio imediato.


## 🎧 12. MEDITAÇÃO E CONTEÚDO GUIADO

O módulo de conteúdo abrange `Meditacao`, `Locutor` e `ProgressoSessao`.
*   **Recursos:** Reprodução em segundo plano, controle e continuação de sessões, e conteúdos exclusivos para assinantes. Cada sessão pode estar associada a um locutor específico.


## 🔔 13. NOTIFICAÇÕES

A classe `Notificacao` gerencia os lembretes do sistema, auxiliando na retenção do usuário.
*   **Categorias:** Lembrete de prática, missão diária e interações de sistema.
*   **Funcionalidades:** Agendamento, cancelamento e agrupamento de alertas.


## 🔗 14. PRINCIPAIS RELACIONAMENTOS

As associações abaixo demonstram a classe `Usuario` como núcleo agregador:

| Origem | Destino | Cardinalidade |
|:---|:---|:---:|
| `Usuario` | `Perfil` | 1 : 1 |
| `Usuario` | `Assinatura` | 1 : 1 |
| `Usuario` | `SessaoAutenticacao` | 1 : N |
| `Usuario` | `RegistroEmocional` | 1 : N |
| `Usuario` | `LeituraCardiaca` | 1 : N |
| `Usuario` | `Conversa` | 1 : N |
| `Usuario` | `Notificacao` | 1 : N |
| `Usuario` | `Relatorio` | 1 : N |
| `Usuario` | `Pet` | 1 : 1 |
| `Usuario` | `Missao` | N : N |
| `Usuario` | `EmblemaDigital` | N : N |


## ✅ 15. CONCLUSÃO

O Diagrama de Classes UML do SlowDown apresenta uma modelagem abrangente e alinhada aos requisitos da aplicação. A estrutura fornece uma base sólida para implementação, contemplando autenticação, monitoramento emocional fisiológico, gamificação e suporte conversacional. Além de representar a arquitetura, estabelece a rastreabilidade direta com as Histórias de Usuário definidas no backlog.

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>
