# Tecnologias e Ferramentas Utilizadas (Tech Stack Map)

Este documento apresenta o ecossistema tecnológico selecionado para o desenvolvimento do sistema **Slow Down**, organizado por camadas e propósitos técnicos, garantindo o alinhamento com os requisitos não-funcionais de desempenho, segurança e funcionamento offline, além de viabilizar a futura implementação ágil do Produto Mínimo Viável (MVP).

## 1. Integração entre as Tecnologias (Explicação do Mapa)

O ecossistema do **Slow Down** foi projetado seguindo o modelo de arquitetura Cliente/Servidor distribuído, com o backend estruturado no padrão MVC. 

O fluxo de dados inicia-se no **Frontend Mobile**, desenvolvido em **Flutter**, que gerencia a interface do usuário e a lógica local (como o armazenamento em cache para o modo offline). O aplicativo conecta-se diretamente a sensores de hardware por meio das APIs nativas **Google Fit** e **Apple HealthKit** para capturar os batimentos cardíacos em tempo real.

A comunicação com o ecossistema de backend é realizada por meio de requisições HTTP em uma API REST padronizada com formato JSON. O **Backend**, construído em **Node.js com Express**, atua como a camada controladora (Controller) da arquitetura, processando as requisições, validando sessões de usuário e aplicando as regras de negócio complexas do sistema (como o motor de cálculo do Índice de Estresse).

A persistência de dados sensíveis e históricos emocionais é delegada à camada de dados (Model), operada pelo banco de dados relacional **MySQL**, que assegura a integridade das informações de saúde e oferece altíssima compatibilidade com o ecossistema do servidor. Para garantir a segurança nas etapas de autenticação, o fluxo de login tradicional e o login social (Google OAuth) são delegados ao **Firebase Authentication**, mitigando riscos de segurança e acelerando o processo de validação de identidade.

---

## 2. Mapa Visual da Tech Stack

![Mapa Visual da Tech Stack](./imagens/tech-stack-map.png)
*Figura 1: Organização visual das tecnologias por propósito e camadas.*

---

## 3. Tabela Detalhada de Tecnologias (Obrigatória)

A tabela abaixo detalha formalmente a atribuição de cada componente tecnológico à sua respectiva camada arquitetural, acompanhada da justificativa de engenharia de software para sua escolha:

| Camada / Propósito | Nome da Tecnologia | Justificativa de Uso |
| :--- | :--- | :--- |
| **Frontend Mobile** | Flutter | Permite o desenvolvimento multiplataforma (Android e iOS) com um único código fonte. Essencial para renderizar os gráficos e gerenciar o cache local para o modo offline. |
| **Backend (API REST)** | Node.js + Express | Ambiente de execução JavaScript leve e assíncrono. Ideal para construir a camada controladora (Controller) da API com alta escalabilidade e baixa latência. |
| **Banco de Dados** | MySQL | Sistema relacional consolidado e de alta performance. Oferece excelente integração com Node.js e garante a integridade do armazenamento dos históricos emocionais. |
| **Autenticação (Segurança)** | Firebase Authentication | Provedor seguro que padroniza o fluxo de login via E-mail/Senha e Google OAuth, eliminando a complexidade de gerenciar criptografia de senhas no banco principal. |
| **Integração de Hardware** | APIs Google Fit / HealthKit | APIs nativas fundamentais para estabelecer a comunicação com os sensores dos dispositivos, permitindo a leitura padronizada de dados biométricos (BPM). |
| **Controle de Versão e CI/CD** | Git + GitHub | Infraestrutura essencial para a gerência de configuração. Permite o versionamento seguro do código, rastreabilidade de commits e trabalho colaborativo por meio de branches. |
| **Gerenciamento Ágil** | GitHub Projects | Utilizado para a manutenção do Backlog do Produto e do Sprint, garantindo o acompanhamento visual das tarefas (Kanban) integrado ao repositório. |
| **Design e Modelagem** | Figma + Visual Paradigm | O Figma será utilizado para a prototipagem de alta fidelidade das interfaces e criação do MVP, enquanto o Visual Paradigm será a ferramenta oficial para projetar os diagramas estruturais e UML do Modelo C4. |
