# Slow Down — Backend v2 (Firebase Auth + MySQL)

Backend do **Slow Down** em **Node.js + Express + MySQL**, agora usando
**Firebase Authentication** (conforme decidido no documento de Tech Stack).

## 🔄 O que mudou da v1 para a v2

| | v1 (JWT próprio) | v2 (Firebase Auth) |
|---|---|---|
| Senha | Hash com bcrypt, salva no MySQL | Gerenciada 100% pelo Firebase |
| Login social (Google) | Não tinha | Sim, via Firebase |
| Token | Gerado pelo nosso backend (JWT) | Gerado pelo Firebase, só validamos |
| Tabela `users` | Tinha `senha_hash` | Tem `firebase_uid` (sem senha) |

## 📁 Estrutura

```
slowdown-backend/
├── database.sql                       # Cria o banco e a tabela users (sem senha)
├── .env.example                        # Modelo das variáveis de ambiente
├── firebase-service-account.json       # ⚠️ VOCÊ precisa colocar este arquivo aqui (não incluso)
├── src/
│   ├── server.js
│   ├── config/
│   │   ├── database.js
│   │   └── firebase.js                 # Inicializa o Firebase Admin SDK
│   ├── models/userModel.js
│   ├── controllers/authController.js   # Sincroniza usuário Firebase ↔ MySQL
│   ├── middlewares/authMiddleware.js   # Valida o token do Firebase
│   └── routes/authRoutes.js
```

## 🚀 Como configurar (passo a passo)

### 1. Coloque o arquivo de credencial do Firebase

Você baixou um arquivo `.json` no Firebase Console (Configurações do projeto →
Contas de serviço → Gerar nova chave privada). Esse arquivo tem um nome como:

```
slowdown-app-c2d1c-firebase-adminsdk-xxxxx.json
```

**Renomeie esse arquivo para `firebase-service-account.json`** e coloque na
**raiz** desta pasta do backend (mesmo nível do `package.json`).

> ⚠️ Esse arquivo é uma credencial sensível. Ele já está no `.gitignore` —
> nunca remova essa linha nem suba ele pro GitHub.

### 2. Configure o `.env`
```bash
copy .env.example .env
```
O padrão já aponta para `./firebase-service-account.json`, então se você
seguiu o passo 1 com o nome exato, não precisa editar nada além dos dados
do MySQL (usuário/senha).

### 3. Crie o banco de dados
Execute o `database.sql` no seu MySQL (phpMyAdmin, Workbench, etc.)

### 4. Instale as dependências
```bash
npm install
```

### 5. Rode o servidor
```bash
npm run dev
```

Se tudo estiver certo:
```
🚀 Servidor rodando em http://localhost:3000
✅ Conectado ao MySQL com sucesso!
```

Se a credencial do Firebase estiver faltando ou for inválida, o servidor
vai mostrar uma mensagem de erro clara apontando exatamente o problema,
em vez de travar com um erro confuso.

## 🔌 Endpoints disponíveis

### `POST /auth/sync`
Chamado pelo Flutter **imediatamente após** o login/cadastro no Firebase
(seja por email/senha ou Google). Sincroniza o usuário com o MySQL —
cria se for a primeira vez, ou apenas retorna os dados se já existir.

**Header obrigatório:**
```
Authorization: Bearer <idToken do Firebase>
```

**Body (JSON, opcional — só é necessário se for o primeiro login por email/senha,
caso o nome não venha embutido no token):**
```json
{ "nome": "Maria Silva" }
```

**Resposta (201 na primeira vez, 200 nas seguintes):**
```json
{
  "mensagem": "Usuário criado com sucesso!",
  "usuario": {
    "id": 1,
    "firebase_uid": "abc123...",
    "nome": "Maria Silva",
    "email": "maria@email.com",
    "plano": "padrao"
  }
}
```

### `GET /auth/me`
Retorna os dados do usuário logado (mesmo header `Authorization` acima).

## ➡️ Próximos passos

1. No Flutter, integrar o SDK do Firebase (`firebase_auth`) nas telas de
   login/cadastro — chamando `/auth/sync` depois do login.
2. Criar a próxima entidade: `emotional_logs` (US-06).
3. Depois: `pets` (US-03).
