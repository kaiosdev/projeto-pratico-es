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

O fluxo de dados inicia-se no **Frontend Mobile**, desenvolvido em **Flutter** e focado exclusivamente na plataforma **Android**. O aplicativo gerencia a interface do usuário e a lógica local (como o cache de áudio para o modo offline) e conecta-se diretamente a sensores de hardware do dispositivo por meio da API nativa **Google Fit**, responsável por capturar os batimentos cardíacos (BPM). Para viabilizar a acessibilidade e o suporte interativo, o frontend integra-se à **Google Speech-to-Text API** para navegação por voz e à **Gemini API** para o processamento de linguagem natural do Chatbot de apoio emocional. O controle de assinaturas do plano Premium é processado via **Stripe API (Modo Sandbox)**, permitindo validar o fluxo financeiro de forma segura e autêntica sem a necessidade de publicação em lojas. Para assegurar que o usuário seja alertado sobre picos de estresse mesmo com o aplicativo fechado, o serviço de mensageria **Firebase Cloud Messaging (FCM)** foi integrado para gerenciar notificações push.

A comunicação com o ecossistema de backend é realizada por meio de requisições HTTP em uma API REST padronizada com formato JSON. O **Backend**, construído em **Node.js com Express**, atua como a camada controladora (Controller) da arquitetura, processando as requisições, validando sessões e aplicando as regras de negócio complexas do sistema (cálculo de Índice de Estresse, gamificação e interações do Pet Virtual).

A persistência de dados sensíveis é delegada à camada de dados (Model), operada pelo **MySQL**, garantindo integridade transacional. Para a autenticação, o fluxo de login tradicional e o login social (Google OAuth) são operados pelo **Firebase Authentication**.

Por fim, a fundação do ciclo de vida do desenvolvimento é sustentada pelo **Git/GitHub** para controle de versão, **GitHub Projects** para a gestão ágil (Kanban), e a utilização conjunta do **Figma** e **Visual Paradigm** para a prototipação e modelagem arquitetural C4.

---

## 2. Mapa Visual da Tech Stack

<div align="center">
  <img src="https://github.com/user-attachments/assets/61ae2515-78d9-4cab-bc67-29b56954f4e3" />
  <p><i><b>Figura 1:</b> Organização visual das tecnologias do Slow Down por propósito e camadas.</i></p>
</div>

<br>

---

## 3. Tabela Detalhada de Tecnologias

| Camada / Propósito | Nome da Tecnologia | Justificativa de Uso |
| :--- | :--- | :--- |
| **Frontend Mobile** | Flutter | Framework ágil focado em Android. Essencial para renderizar a gamificação e gerenciar o cache local para execução das HUs offline. |
| **Backend (API REST)** | Node.js + Express | Ambiente de execução JavaScript assíncrono. Ideal para a camada controladora (Controller) e processamento de regras de negócio. |
| **Banco de Dados** | MySQL | Sistema relacional consolidado. Garante a integridade do histórico emocional, inventário do Pet e parâmetros de saúde. |
| **Autenticação** | Firebase Auth | Provedor que padroniza o fluxo de login sem armazenar senhas brutas, garantindo segurança ao sistema. |
| **IA & Acessibilidade** | Gemini API + Speech-to-Text | Tecnologias para transformar comandos de voz em ações e prover suporte contextualizado via chatbot assistente. |
| **Pagamentos** | Stripe API (Sandbox) | Gateway flexível para gestão de assinaturas Premium, validando o fluxo financeiro no ambiente de teste do MVP. |
| **Notificações Push** | Firebase FCM | Serviço essencial para alertas visuais/vibratórios de frequência cardíaca e lembretes de autocuidado em background. |
| **Integração Hardware** | API Google Fit | Comunicação direta com sensores Android para leitura padronizada de dados biométricos em tempo real. |
| **Controle de Versão** | Git + GitHub | Infraestrutura para gerência de configuração, rastreabilidade de commits e trabalho colaborativo por branches. |
| **Gerenciamento Ágil** | GitHub Projects | Manutenção do Backlog do Produto e Sprints, garantindo acompanhamento visual integrado ao código. |
| **Design e Modelagem** | Figma + Visual Paradigm | Prototipagem de alta fidelidade das interfaces e modelagem rigorosa dos diagramas do Modelo C4. |

<br>

---

<div align="center">

  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>

</div>
