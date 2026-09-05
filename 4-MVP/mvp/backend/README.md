<div align="center">
  <img src="https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white" alt="Node.js">
  <img src="https://img.shields.io/badge/Express.js-404D59?style=for-the-badge&logo=express&logoColor=white" alt="Express">
  <img src="https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL">
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">
  
  <h1>🧘 SlowDown App — Backend</h1>
  <p><b>API RESTful para gestão de usuários, autenticação OTP e integração Firebase do ecossistema SlowDown.</b></p>
</div>

<hr>

## 📋 Sobre o Projeto
O **SlowDown Backend** é o motor de dados do nosso ecossistema de saúde e bem-estar. Esta API gerencia o banco de dados relacional (MySQL), a sincronização de usuários via **Firebase Authentication** e a lógica rigorosa de validação de segurança em duas etapas (OTP).

## 🛠️ Ferramentas Necessárias

Para rodar o servidor localmente na sua máquina, você precisará ter instalado:

- [Node.js](https://nodejs.org/pt-br/) (Versão 18 ou superior)
- [MySQL Server](https://dev.mysql.com/downloads/) (Gerenciador do banco de dados)
- Conta no [Firebase Console](https://console.firebase.google.com/) com acesso ao SDK Admin
- Editor de código: [VS Code](https://code.visualstudio.com/)
- Ferramenta de requisições REST (Opcional): [Insomnia](https://insomnia.rest/) ou Postman


## 🔗 Configuração de Ambiente (Banco e Firebase)

### Passo 1: Credenciais do Firebase
O backend depende de uma chave privada do Firebase para validar os tokens de login social e as sessões do aplicativo.

1. Baixe o arquivo `.json` no Firebase Console (*Configurações do projeto → Contas de serviço → Gerar nova chave privada*).
2. Renomeie o arquivo baixado para `firebase-service-account.json`.
3. Cole o arquivo na **raiz** do projeto backend (mesmo nível do arquivo `package.json`).

> ⚠️ **Atenção:** Este arquivo é uma credencial sensível. Ele já está configurado no `.gitignore` — **nunca** suba esse arquivo para o GitHub.

### Passo 2: Variáveis de Ambiente e Banco de Dados
1. No terminal, faça uma cópia do arquivo de exemplo para criar o seu arquivo local de ambiente:
```bash
copy .env.example .env
```
2. Abra o `.env` e preencha as credenciais do seu MySQL local (usuário, senha e porta).
3. Execute o script `database.sql` na sua interface de banco de dados (ex: MySQL Workbench) para criar a estrutura inicial da tabela `users`.

---

## 🚀 Como Executar o Projeto

Com o banco de dados criado e o Firebase configurado, siga os passos abaixo no seu terminal:

**1. Clone o repositório:**
```bash
git clone [https://github.com/kaiosdev/projeto-pratico-es/tree/main/4-MVP/mvp/backend.git](https://github.com/kaiosdev/projeto-pratico-es/tree/main/4-MVP/mvp/backend.git)
cd slowdown-backend
```

**2. Instale as dependências do Node:**
```bash
npm install
```

**3. Inicie o servidor (Modo de Desenvolvimento):**
```bash
npm run dev
```

Se tudo estiver configurado corretamente, o console exibirá:
```text
🚀 Servidor rodando em http://localhost:3000
✅ Conectado ao MySQL com sucesso!
```

---

## 🔌 Endpoints Principais Disponíveis

A API expõe as seguintes rotas para consumo do Frontend Flutter:

- `POST /auth/sync` — Sincroniza o usuário (Firebase ↔ MySQL) na criação da conta. Requer Header `Authorization: Bearer <token>`.
- `POST /auth/verify-otp` —  Rota pública que valida o código de 6 dígitos gerado no fluxo de cadastro.
- `GET /auth/me` — Retorna os dados completos do usuário autenticado no momento.

---

## 📁 Estrutura do Projeto

A arquitetura segue o padrão de roteamento modular do Express:

```text
slowdown-backend/
 ┣ 📂 src/
 ┃ ┣ 📂 config/        # Arquivos de conexão (database.js, firebase.js)
 ┃ ┣ 📂 controllers/   # Lógica de negócio e respostas (authController.js)
 ┃ ┣ 📂 middlewares/   # Interceptadores de segurança (authMiddleware.js)
 ┃ ┣ 📂 models/        # Interação e queries no banco (userModel.js)
 ┃ ┣ 📂 routes/        # Definição dos endpoints da API (authRoutes.js)
 ┃ ┗ 📜 server.js      # Ponto de entrada e inicialização do servidor Express
 ┣ 📜 database.sql     # Script de criação das tabelas relacionais
 ┣ 📜 .env             # Variáveis de ambiente locais
 ┗ 📜 package.json     # Gerenciamento de pacotes e scripts do Node
```

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software  · ICET/UFAM</sub>
</div>
