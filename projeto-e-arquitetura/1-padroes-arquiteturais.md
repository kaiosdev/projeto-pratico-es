<div align="center">

# 💻 Padrões Arquiteturais — SlowDown

*Engenharia de Software A · ICET/UFAM*

![Arquitetura](https://img.shields.io/badge/Padrão-MVC-4a90d9?style=for-the-badge&logo=databricks&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-2e7d32?style=for-the-badge)

</div>

---

## 1. MVC — Model-View-Controller

O padrão arquitetural adotado para o desenvolvimento do **SlowDown** foi o **MVC (Model-View-Controller)**. Esse padrão organiza a aplicação em três componentes principais:

<div align="center">

```
<img width="717" height="472" alt="MVC MARCO TÚLIO" src="https://github.com/user-attachments/assets/f0b8a7cb-9ae0-41af-9f96-79878557890f" />

```

</div>

| Componente | Responsabilidade |
|:---:|:---|
| **Model** | Gerencia os dados e as regras de negócio da aplicação |
| **View** | Responsável pela interface e apresentação das informações ao usuário |
| **Controller** | Recebe interações do usuário e coordena a comunicação entre interface e dados |

> **Característica central:** a separação de responsabilidades entre os componentes reduz o acoplamento e torna o sistema mais organizado, manutenível e escalável. Alterações na interface podem ser realizadas sem impactar as regras de negócio e vice-versa.

### No contexto do SlowDown

| Camada | Elementos |
|:---|:---|
| **Model** | Usuários, registros emocionais, missões, conquistas, sessões de meditação, chatbot, configurações |
| **View** | Login, onboarding, termômetro emocional, relatórios, pet virtual, configurações |
| **Controller** | Intermediação entre ações do usuário e processamento das funcionalidades do sistema |

---

## 2. Justificativa da Escolha

A arquitetura MVC foi escolhida por atender adequadamente às necessidades do **SlowDown**, que reúne diversas funcionalidades independentes, como monitoramento emocional, meditações guiadas, chatbot, gamificação, sistema de conquistas, relatórios e suporte offline.

Como essas funcionalidades **compartilham dados do usuário e regras de negócio**, a separação proposta pelo MVC ajuda a manter o código organizado e evita que a lógica da aplicação fique misturada com a interface — o que facilita o desenvolvimento colaborativo, permite maior reutilização de código e reduz a complexidade à medida que novas funcionalidades são adicionadas.

### Contribuição para os Requisitos Não Funcionais

| Requisito | Contribuição do MVC |
|:---|:---|
| **Manutenção** | Permite correções e evoluções sem afetar toda a aplicação |
| **Escalabilidade** | Facilita a inclusão de novos recursos e módulos |
| **Usabilidade** | Possibilita evoluir a interface de forma independente das regras de negócio |
| **Confiabilidade** | Centraliza a lógica do sistema, reduzindo inconsistências |
| **Suporte Offline** | Facilita o gerenciamento local dos dados e a sincronização posterior |

---

## 3. Aplicação do MVC no SlowDown

A arquitetura MVC permite distribuir responsabilidades de forma clara entre os componentes do sistema:

```
┌─────────────────────────────────────────────────────┐
│                 Aplicação SlowDown                  │
│                                                     │
│   ┌──────────┐    ┌──────────────┐   ┌──────────┐  │
│   │   VIEW   │◄───│  CONTROLLER  │──►│  MODEL   │  │
│   │          │───►│              │◄──│          │  │
│   │ Telas do │    │ Intermediário│   │ Dados e  │  │
│   │   App    │    │ de ações     │   │  Regras  │  │
│   └──────────┘    └──────────────┘   └──────────┘  │
└─────────────────────────────────────────────────────┘
```

Essa separação **favorece a organização do código**, reduz o acoplamento entre componentes e facilita futuras evoluções da aplicação.

---

## 4. Detalhamento dos Componentes

### 4.1 Camada de Apresentação — View

> Localizada na camada mais próxima do usuário, a **View** é responsável por toda a interface gráfica e pela exibição das informações processadas pelo sistema.

Telas presentes nessa camada:

- Login e Cadastro
- Onboarding
- Termômetro Emocional
- Sessões de Meditação
- Chatbot
- Pet Virtual
- Sistema de Missões e Conquistas
- Relatórios de Evolução Emocional
- Notificações e Configurações

> **Atenção:** a View **não possui regras de negócio**. Sua responsabilidade é capturar interações do usuário e apresentar dados de forma clara, intuitiva e acessível.

---

### 4.2 Camada de Controle — Controller

> O **Controller** atua como intermediário entre a interface e as regras de negócio, recebendo ações do usuário, validando informações e coordenando a execução dos processos necessários.

Principais responsabilidades no SlowDown:

- Gerenciamento do fluxo de autenticação e acesso ao sistema
- Registro dos estados emocionais informados pelos usuários
- Controle das sessões de meditação e conteúdos de áudio
- Processamento das missões diárias, XP e desbloqueio de conquistas
- Gerenciamento das interações com o chatbot
- Controle das notificações personalizadas
- Gerenciamento da sincronização de dados entre modo offline e online

---

### 4.3 Camada de Modelo — Model

> O **Model** representa o núcleo de dados e regras de negócio do sistema, mantendo a integridade das informações e garantindo que as regras de negócio sejam aplicadas de forma consistente.

Principais elementos do Model:

| Categoria | Elementos |
|:---|:---|
| **Usuários** | Perfis e dados de cadastro |
| **Saúde Emocional** | Registros emocionais, histórico de humor e estresse |
| **Conteúdo** | Sessões de meditação e áudios |
| **Gamificação** | Sistema de missões, XP, emblemas e dados do pet virtual |
| **Sistema** | Configurações de notificações, relatórios e métricas |
| **Offline** | Informações armazenadas para funcionamento sem conexão |

---

### 4.4 Persistência de Dados e Serviços Externos

Os dados dos usuários, registros emocionais, progresso das missões, conquistas, preferências e histórico de utilização são armazenados em **banco de dados**, permitindo recuperação, atualização e sincronização entre diferentes sessões de uso.

A aplicação integra serviços externos para funcionalidades específicas:

| Serviço | Finalidade |
|:---|:---|
| **Autenticação** | Gerenciamento seguro de contas de usuário |
| **Notificações Push** | Lembretes personalizados de autocuidado |
| **Reconhecimento de Voz** | Acessibilidade e navegação mãos-livres |
| **IA / Chatbot (API)** | Processamento de linguagem natural e respostas adaptativas |
| **Sincronização em Nuvem** | Suporte ao modo offline com sincronização posterior |

> Essas integrações permanecem **desacopladas das regras de negócio**, permitindo futuras expansões ou substituições sem impactar a estrutura principal da aplicação.

---

## 5. Fluxo Geral da Arquitetura

O funcionamento da arquitetura MVC no SlowDown ocorre da seguinte forma:

```
  Usuário
    │
    ▼
┌───────┐     ação      ┌────────────┐    processa    ┌─────────┐
│  VIEW │ ─────────────►│ CONTROLLER │───────────────►│  MODEL  │
│       │               │            │◄───────────────│         │
│       │◄──────────────│            │    resultado   │  dados  │
└───────┘  atualiza UI  └────────────┘                └─────────┘
    │                                                      │
    ▼                                                      ▼
Resultado                                         Banco de Dados
ao Usuário                                        / Serv. Externos
```

### Sequência de execução

| Etapa | Ação |
|:---:|:---|
| **1** | O usuário interage com uma tela da aplicação (View) |
| **2** | A ação é recebida pelo Controller |
| **3** | O Controller processa a solicitação e aciona o Model |
| **4** | O Model executa as regras de negócio e acessa os dados necessários |
| **5** | O resultado retorna ao Controller |
| **6** | O Controller atualiza a View com as informações processadas |
| **7** | A interface apresenta o resultado ao usuário |

> Esse fluxo garante uma **separação clara de responsabilidades**, contribuindo para a organização do sistema, facilidade de manutenção, escalabilidade e evolução contínua da aplicação.

*Fonte: Elaborado pelos autores (2026).*

---

## 6. Conclusão

A arquitetura **MVC** foi escolhida por oferecer uma solução simples, robusta e amplamente utilizada pela indústria para aplicações que exigem gerenciamento de dados, interação constante com o usuário e evolução contínua das funcionalidades.

Sua adoção permite que o SlowDown mantenha uma estrutura organizada desde as primeiras versões do projeto, facilitando o **desenvolvimento colaborativo** da equipe e garantindo maior qualidade na implementação das funcionalidades previstas no backlog.

Além de atender aos objetivos do projeto e às necessidades do domínio da saúde mental preventiva, o MVC fornece uma base sólida para futuras expansões da plataforma, preservando manutenibilidade, escalabilidade, confiabilidade e experiência do usuário ao longo de todo o ciclo de vida da aplicação.

---

<div align="center">

<sub>Desenvolvido para a disciplina de Engenharia de Software A · ICET/UFAM<br>
Professor: Dr. Andrey Rodrigues</sub>

</div>
