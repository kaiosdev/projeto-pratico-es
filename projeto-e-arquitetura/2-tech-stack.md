<div align="center">

# 💻 TECNOLOGIAS E FERRAMENTAS (TECH STACK)
*Trabalho Prático II — Engenharia de Software A*

<img src="https://img.shields.io/badge/Status-Concluído-blue?style=for-the-badge" alt="Status">

<br><br>

| Campo | Informação |
|:---|:---|
| **Responsável** | Evelly |
| **Projeto** | Slow Down |
| **Documento** | Tech Stack Map |
| **Status da Entrega** | Concluído |

</div>

<br>

---

Este documento apresenta o ecossistema tecnológico selecionado para o desenvolvimento do sistema **Slow Down**, organizado por camadas e propósitos técnicos, garantindo o alinhamento com os requisitos não-funcionais de desempenho, segurança e funcionamento offline, além de viabilizar a futura implementação ágil do Produto Mínimo Viável (MVP).

## 1. Integração entre as Tecnologias (Explicação do Mapa)

O ecossistema do **Slow Down** foi projetado seguindo o modelo de arquitetura Cliente/Servidor distribuído, com o backend estruturado sob o padrão MVC.

O fluxo de dados inicia-se no **Frontend Mobile**, desenvolvido em **Flutter** e focado exclusivamente na plataforma **Android**. O aplicativo gerencia a interface do usuário e a lógica local (como o cache de áudio para o modo offline) e conecta-se diretamente a sensores de hardware do dispositivo por meio da API nativa **Google Fit**, responsável por capturar os batimentos cardíacos (BPM). Para viabilizar a acessibilidade e o suporte interativo, o frontend integra-se à **Google Speech-to-Text API** para navegação por voz e à **Gemini API** para o processamento de linguagem natural do Chatbot de apoio emocional. O controle de assinaturas do plano Premium é processado de forma segura e nativa através do **Google Play Billing**. Para assegurar que o usuário seja alertado sobre picos de estresse mesmo com o aplicativo fechado, o serviço de mensageria **Firebase Cloud Messaging (FCM)** foi integrado para gerenciar notificações push.

A comunicação com o ecossistema de backend é realizada por meio de requisições HTTP em uma API REST padronizada com formato JSON. O **Backend**, construído em **Node.js com Express**, atua como a camada controladora (Controller) da arquitetura, processando as requisições, validando sessões de usuário e aplicando as regras de negócio complexas do sistema, como o cálculo do Índice de Estresse, a progressão de XP (Gamificação) e as interações do Pet Virtual.

A persistência de dados sensíveis e dos históricos emocionais é delegada à camada de dados (Model), operada pelo banco de dados relacional **MySQL**, que assegura a integridade transacional das informações de saúde e oferece excelente integração com o ambiente Node.js. Para garantir a segurança nas etapas de autenticação, o fluxo de login tradicional e o login social (Google OAuth) são operados pelo **Firebase Authentication**, mitigando riscos de segurança e acelerando a validação de identidade.

Por fim, a fundação do ciclo de vida do desenvolvimento e do design é sustentada pelo **Git e GitHub** para o controle de versão colaborativo, **GitHub Projects** para a gestão ágil das tarefas da equipe (Kanban), e a utilização conjunta do **Figma** e **Visual Paradigm** para a prototipação de alta fidelidade das interfaces e modelagem rigorosa dos diagramas arquiteturais C4.

---

## 2. Mapa Visual da Tech Stack

<div align="center">
  <img src="./imagens/tech-stack-map.png" alt="Mapa Visual da Tech Stack" width="800" />
  <p><i><b>Figura 1:</b> Organização visual das tecnologias do Slow Down por propósito e camadas.</i></p>
</div>

<br>

---

## 3. Tabela Detalhada de Tecnologias (Obrigatória)

A tabela abaixo detalha formalmente a atribuição de cada componente tecnológico à sua respectiva camada arquitetural, acompanhada da justificativa de engenharia de software para sua escolha:

| Camada / Propósito | Nome da Tecnologia | Justificativa de Uso |
| :--- | :--- | :--- |
| **Frontend Mobile** | Flutter | Framework ágil focado na versão Android. Essencial para renderizar a gamificação (Pet Virtual) e gerenciar o cache local para execução das Histórias de Usuário offline. |
| **Backend (API REST)** | Node.js + Express | Ambiente de execução JavaScript leve e assíncrono. Ideal para construir a camada controladora (Controller) responsável pelo motor de relatórios, validação de missões e XP. |
| **Banco de Dados** | MySQL | Sistema relacional consolidado e de alta performance. Garante a integridade do armazenamento dos históricos emocionais, inventário do Pet e parâmetros de saúde. |
| **Autenticação (Segurança)** | Firebase Authentication | Provedor seguro que padroniza o fluxo de login e gerencia as sessões dos diferentes perfis (Padrão, Premium e Acessibilidade) sem armazenar senhas brutas no banco. |
| **IA & Acessibilidade** | Gemini API + Speech-to-Text | Tecnologias encarregadas de transformar comandos de voz em ações no app e de prover respostas contextualizadas e empáticas através do Chatbot assistente. |
| **Pagamentos** | Google Play Billing | Gateway oficial e nativo do ecossistema Android para validar a conversão de usuários Padrão para Premium e liberar o acesso irrestrito às ferramentas do aplicativo. |
| **Notificações Push** | Firebase Cloud Messaging (FCM) | Serviço essencial para disparar os alertas visuais e vibratórios de frequência cardíaca elevada e os lembretes de autocuidado em segundo plano. |
| **Integração de Hardware** | API Google Fit | API nativa fundamental para estabelecer a comunicação direta com os sensores Android, permitindo a leitura padronizada de dados biométricos em tempo real. |
| **Controle de Versão e CI/CD** | Git + GitHub | Infraestrutura essencial para a gerência de configuração. Permite o versionamento seguro do código, rastreabilidade de commits e trabalho colaborativo por meio de branches. |
| **Gerenciamento Ágil** | GitHub Projects | Utilizado para a manutenção do Backlog do Produto e do Sprint, garantindo o acompanhamento visual das tarefas (Kanban) integrado ao repositório do código-fonte. |
| **Design e Modelagem** | Figma + Visual Paradigm | O Figma prototipará em alta fidelidade as interfaces do MVP, enquanto o Visual Paradigm projetará a estrutura UML e os diagramas do Modelo C4. |

<br>

---

<div align="center">

  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>

</div>
