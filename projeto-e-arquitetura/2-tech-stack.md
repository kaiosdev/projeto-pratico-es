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
| **Frontend Mobile** | Flutter | Permite o desenvolvimento multiplataforma (Android e iOS) com um único código fonte de alto desempenho. Essencial para renderizar os gráficos de evolução emocional e gerenciar o cache local de áudio para o funcionamento offline. |
| **Backend (API REST)** | Node.js + Express | Ambiente de execução JavaScript leve, assíncrono e orientado a eventos. Ideal para construir a camada controladora (Controller) da API com alta escalabilidade e baixa latência nas requisições do aplicativo. |
| **Banco de Dados Relacional** | MySQL | Sistema de gerenciamento de banco de dados relacional consolidado e de alta performance. Oferece excelente integração com Node.js (facilitando a codificação do MVP) e garante a integridade do armazenamento dos históricos de humor e logs cardíacos. |
| **Autenticação e Segurança** | Firebase Authentication | Provedor de identidade seguro que simplifica e padroniza o fluxo de login via E-mail/Senha e o Login Social (Google OAuth), eliminando a necessidade de gerenciar complexidades de criptografia de senhas localmente. |
| **Integração de Hardware** | APIs Google Fit / HealthKit | APIs nativas fundamentais para estabelecer a comunicação direta com os sensores dos dispositivos móveis ou smartwatches, permitindo a leitura padronizada de dados biométricos (BPM). |
| **Design e Modelagem** | Figma / Draw.io | Ferramentas utilizadas cooperativamente pela equipe para a prototipagem de telas e para a modelagem visual de todos os diagramas arquiteturais do Modelo C4. |
