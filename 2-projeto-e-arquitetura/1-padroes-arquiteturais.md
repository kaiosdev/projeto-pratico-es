<div align="center">

# 💻 Padrões Arquiteturais — SlowDown

*Engenharia de Software A · ICET/UFAM*

![Arquitetura](https://img.shields.io/badge/Padrão-MVC-4a90d9?style=for-the-badge&logo=databricks&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge)

</div>

## 4. Padrões Arquiteturais

### 4.1 Descrição do Padrão Arquitetural

O padrão arquitetural adotado para o desenvolvimento do **SlowDown** foi o **Model-View-Controller (MVC)**. Esse padrão é amplamente utilizado no desenvolvimento de sistemas por promover a separação de responsabilidades entre os componentes da aplicação, facilitando a organização, manutenção e evolução do software.

O MVC organiza o sistema em três camadas principais:

| Componente | Responsabilidade |
|:---:|:---|
| **Model** | Responsável pelos dados, regras de negócio e persistência das informações da aplicação |
| **View** | Responsável pela interface gráfica e pela interação com o usuário |
| **Controller** | Recebe as solicitações da interface, processa as regras necessárias e coordena a comunicação entre a View e o Model |

> **Característica central:** a divisão clara entre apresentação, processamento e dados reduz o acoplamento entre os componentes do sistema. Essa organização permite que alterações na interface não impactem diretamente as regras de negócio e vice-versa, favorecendo a reutilização de código e a escalabilidade da aplicação.

### No contexto do SlowDown

| Camada | Tecnologia |
|:---|:---|
| **View** | Framework Flutter |
| **Controller** | API REST desenvolvida em Node.js e Express |
| **Model** | Regras de negócio e acesso aos dados armazenados no banco de dados MySQL, além das integrações com serviços externos |

> A organização da arquitetura MVC utilizada no projeto pode ser observada na Figura 1.

**Figura 1 – Arquitetura MVC aplicada ao sistema SlowDown.**

<img width="1774" height="441" alt="MVC" src="https://github.com/user-attachments/assets/b53036ad-7ee6-4335-8022-39b2bcb41273" />

### 4.2 Justificativa da Escolha

O padrão MVC foi escolhido por atender adequadamente às necessidades do sistema **SlowDown**, uma aplicação voltada ao apoio da saúde mental preventiva que integra diversas funcionalidades, como monitoramento emocional, meditações guiadas, chatbot inteligente, gamificação, relatórios de evolução emocional, notificações personalizadas e suporte offline.

Como essas funcionalidades **compartilham dados e regras de negócio**, a utilização do MVC contribui para manter o sistema organizado e modular, evitando que a lógica da aplicação fique misturada à interface gráfica.

Além disso, o padrão ajuda a resolver problemas comuns em projetos de software:

- Alto acoplamento entre componentes
- Dificuldade de manutenção e evolução do código
- Baixa reutilização de funcionalidades
- Crescimento desorganizado da aplicação
- Dificuldade de trabalho colaborativo entre os membros da equipe

### Contribuição para os Requisitos Não Funcionais

| Requisito | Contribuição do MVC |
|:---|:---|
| **Manutenibilidade** | Permite correções e evoluções sem afetar toda a aplicação |
| **Escalabilidade** | Facilita a inclusão de novos recursos e módulos sem comprometer a estrutura principal |
| **Confiabilidade** | Centraliza a lógica do sistema, reduzindo inconsistências |
| **Usabilidade** | Possibilita evoluir a interface de forma independente das regras de negócio |

### 4.3 Camada de Apresentação — View

> Desenvolvida com o framework **Flutter**, a camada View é responsável por toda a interface gráfica e pela exibição das informações processadas pelo sistema.

Telas e funcionalidades presentes nessa camada:

- Login e Cadastro
- Onboarding
- Termômetro Emocional
- Sessões de Meditação
- Chatbot Assistente
- Pet Virtual
- Sistema de Missões e Conquistas
- Relatórios de Evolução Emocional
- Configurações e Notificações

> **Atenção:** a View **não possui regras de negócio**. Sua responsabilidade é capturar as ações do usuário e apresentar as informações processadas pelo sistema de maneira intuitiva e acessível.

#### 4.3.1 Camada de Controle — Controller

> O **Controller** é implementado por meio de uma **API REST em Node.js e Express**, atuando como intermediário entre a interface e as regras de negócio.

Principais responsabilidades no SlowDown:

- Processar autenticação de usuários
- Receber e validar registros emocionais
- Gerenciar sessões de meditação
- Processar missões, XP e conquistas
- Coordenar interações com o chatbot
- Controlar notificações personalizadas
- Gerenciar a sincronização entre os modos online e offline
- Intermediar o acesso às regras de negócio e aos dados armazenados

#### 4.3.2 Camada de Modelo — Model

> O **Model** concentra os dados, as regras de negócio da aplicação e o acesso ao banco de dados **MySQL**, mantendo a integridade das informações de forma consistente.

Principais elementos do Model:

| Categoria | Elementos |
|:---|:---|
| **Usuários** | Perfis e dados de cadastro |
| **Saúde Emocional** | Histórico emocional e registros de humor |
| **Conteúdo** | Sessões de meditação e conteúdos de áudio |
| **Gamificação** | Sistema de missões, XP, conquistas e dados do pet virtual |
| **Sistema** | Relatórios, métricas de utilização e configurações do usuário |
| **Offline** | Dados armazenados localmente para funcionamento sem conexão |

#### 4.3.4 Persistência de Dados e Serviços Externos

Além do banco de dados MySQL, o sistema integra serviços externos que complementam as funcionalidades do aplicativo:

| Serviço | Finalidade |
|:---|:---|
| **Firebase Auth** | Autenticação segura de usuários |
| **Firebase Cloud Messaging (FCM)** | Notificações push personalizadas |
| **Gemini API** | Chatbot com inteligência artificial |
| **Speech-to-Text** | Reconhecimento de voz e acessibilidade |
| **Stripe API (Sandbox)** | Validação do fluxo de assinaturas Premium |
| **Google Fit API** | Obtenção de dados biométricos e sensores do dispositivo |

> Essas integrações permanecem **desacopladas das regras de negócio**, permitindo futuras expansões ou substituições sem impactar a estrutura principal da aplicação.

## 5. Fluxo Geral da Arquitetura

O funcionamento da arquitetura MVC no SlowDown ocorre da seguinte forma:

<img width="1774" height="439" alt="fluxo geral" src="https://github.com/user-attachments/assets/0a2bccc9-88b4-4d81-a93d-ca15de39ab1a" />

### Sequência de execução

| Etapa | Ação |
|:---:|:---|
| **1** | O usuário interage com uma tela da aplicação (View — Flutter) |
| **2** | A ação é enviada para a API REST (Controller — Node.js + Express) |
| **3** | O Controller processa a requisição e aciona o Model |
| **4** | O Model executa as regras de negócio e acessa os dados no MySQL ou serviços externos |
| **5** | O resultado retorna ao Controller |
| **6** | O Controller atualiza a View com as informações processadas |
| **7** | A interface Flutter apresenta o resultado ao usuário |

> Esse fluxo garante uma **separação clara de responsabilidades**, contribuindo para a organização do sistema, facilidade de manutenção, escalabilidade e evolução contínua da aplicação.

## 6. Conclusão

A arquitetura **MVC** foi escolhida por oferecer uma solução simples, robusta e amplamente utilizada pela indústria para aplicações que exigem gerenciamento de dados, interação constante com o usuário e evolução contínua das funcionalidades.

Sua adoção permite que o SlowDown mantenha uma estrutura organizada desde as primeiras versões do projeto, com camadas bem definidas: **Flutter** na apresentação, **Node.js + Express** no controle e **MySQL** na persistência dos dados. Isso facilita o **desenvolvimento colaborativo** da equipe e garante maior qualidade na implementação das funcionalidades previstas no backlog.

Além de atender aos objetivos do projeto e às necessidades do domínio da saúde mental preventiva, o MVC fornece uma base sólida para futuras expansões da plataforma, preservando manutenibilidade, escalabilidade, confiabilidade e experiência do usuário ao longo de todo o ciclo de vida da aplicação.

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software A - ICET/UFAM. <br /> Professor: Dr. Andrey Rodrigues</sub>
</div>
