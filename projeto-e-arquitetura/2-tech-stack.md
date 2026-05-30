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

O fluxo de dados inicia-se no **Frontend Mobile**, desenvolvido em **Flutter** e focado exclusivamente na plataforma **Android**. O aplicativo gerencia a interface do usuário e a lógica local (como o armazenamento em cache para o modo offline) e conecta-se diretamente aos sensores de hardware do dispositivo por meio da API nativa **Google Fit**, responsável por capturar os batimentos cardíacos (BPM) do usuário. Para assegurar que o usuário seja alertado sobre picos de estresse mesmo com o aplicativo fechado, o serviço de mensageria **Firebase Cloud Messaging (FCM)** foi integrado para gerenciar as notificações push.

A comunicação com o ecossistema de backend é realizada por meio de requisições HTTP em uma API REST padronizada com formato JSON. O **Backend**, construído em **Node.js com Express**, atua como a camada controladora (Controller) da arquitetura, processando as requisições, validando sessões de usuário e aplicando as regras de negócio complexas do sistema (como o motor de cálculo e ponderação do Índice de Estresse).

A persistência de dados sensíveis e dos históricos emocionais é delegada à camada de dados (Model), operada pelo banco de dados relacional **MySQL**, que assegura a integridade transacional das informações de saúde e oferece excelente integração de bibliotecas com o ambiente Node.js. Para garantir a segurança nas etapas de autenticação, o fluxo de login tradicional e o login social (Google OAuth) são operados pelo **Firebase Authentication**, mitigando riscos de segurança e acelerando o processo de validação de identidade.

Por fim, a fundação do ciclo de vida do desenvolvimento de software e do design é sustentada pelo **Git e GitHub** para o controle de versão contínuo e colaborativo, **GitHub Projects** para a gestão ágil das tarefas da equipe (Kanban), e a utilização conjunta do **Figma** e **Visual Paradigm** para a prototipação de alta fidelidade das interfaces e modelagem rigorosa dos diagramas arquiteturais do Modelo C4.

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
| **Frontend Mobile** | Flutter | Framework escolhido para o desenvolvimento ágil da interface nativa focada exclusivamente na versão Android do aplicativo. Essencial para renderizar os gráficos e gerenciar o cache local offline. |
| **Backend (API REST)** | Node.js + Express | Ambiente de execução JavaScript leve e assíncrono. Ideal para construir a camada controladora (Controller) da API com alta escalabilidade e baixa latência nas requisições. |
| **Banco de Dados** | MySQL | Sistema relacional consolidado e de alta performance. Oferece excelente integração com Node.js e garante a integridade do armazenamento dos históricos emocionais e parâmetros de saúde. |
| **Autenticação (Segurança)** | Firebase Authentication | Provedor seguro que padroniza o fluxo de login via E-mail/Senha e Google OAuth, eliminando a complexidade de gerenciar a criptografia de senhas no banco de dados principal. |
| **Notificações Push** | Firebase Cloud Messaging (FCM) | Serviço de mensageria essencial para disparar os alertas visuais e vibratórios de frequência cardíaca elevada, garantindo a entrega do alerta mesmo quando o aplicativo estiver operando em segundo plano. |
| **Integração de Hardware** | API Google Fit | API nativa fundamental para estabelecer a comunicação direta com os sensores do ecossistema Android, permitindo a leitura padronizada de dados biométricos (BPM). |
| **Controle de Versão e CI/CD** | Git + GitHub | Infraestrutura essencial para a gerência de configuração. Permite o versionamento seguro do código, rastreabilidade de commits e trabalho colaborativo eficiente por meio de branches. |
| **Gerenciamento Ágil** | GitHub Projects | Utilizado para a manutenção do Backlog do Produto e do Sprint, garantindo o acompanhamento visual das tarefas (Kanban) perfeitamente integrado ao repositório do código-fonte. |
| **Design e Modelagem** | Figma + Visual Paradigm | O Figma será utilizado para a prototipagem de alta fidelidade das interfaces do MVP, enquanto o Visual Paradigm será a ferramenta oficial para projetar os diagramas UML e estruturais do Modelo C4. |

<br>

---

<div align="center">

  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>

</div>
