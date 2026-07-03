# Integração Auth — Flutter ↔ Backend

Este pacote contém os arquivos **novos** e **alterados** para conectar as telas
de login e cadastro do Flutter ao backend (`slowdown-backend`) que já está pronto.

## 📂 Arquivos novos (criar)

Copie estes 3 arquivos para dentro de `lib/src/services/` do seu projeto Flutter
(crie a pasta `services` se não existir):

- `lib/src/services/api_config.dart` — guarda a URL do backend
- `lib/src/services/auth_service.dart` — faz as chamadas HTTP de login/cadastro
- `lib/src/services/session_manager.dart` — guarda o token JWT no dispositivo

## 📝 Arquivos alterados (substituir)

Estes 2 arquivos já existiam no seu projeto e foram modificados — **substitua
os originais por estes**:

- `lib/screens/login_screen.dart`
- `lib/screens/register_screen.dart`

O que mudou neles: a função `_handleLogin` / `_handleRegister`, que antes só
navegava direto pra Home (TODO comentado), agora chama o `AuthService` de
verdade e trata erro (ex: email já cadastrado, senha errada, backend fora do ar).

## ⚙️ pubspec.yaml

Foram adicionadas 2 dependências novas:
```yaml
http: ^1.2.2
shared_preferences: ^2.3.2
```
Adicione essas linhas no seu `pubspec.yaml` (dentro de `dependencies:`) e rode:
```bash
flutter pub get
```

## ✅ Como testar (passo a passo)

1. **Suba o backend primeiro** (na pasta `slowdown-backend`):
   ```bash
   npm run dev
   ```
   Confirme que aparece `🚀 Servidor rodando em http://localhost:3000` e
   `✅ Conectado ao MySQL com sucesso!`

2. **Aplique os arquivos deste pacote** no seu projeto Flutter.

3. **Rode o app no Chrome**:
   ```bash
   flutter run -d chrome
   ```

4. Na tela de **cadastro**, crie uma conta de teste (nome, email, senha com
   6+ caracteres e pelo menos 1 número). Se der certo, você é redirecionado
   para a Home — e o usuário já está salvo no MySQL.

5. Faça **logout** (se já tiver um botão) ou recarregue o app e tente
   fazer **login** com o mesmo email/senha. Deve funcionar.

6. Teste um erro de propósito: tente cadastrar o mesmo email duas vezes.
   Deve aparecer a mensagem "Este email já está cadastrado." vinda direto
   do backend.

## 🐛 Erros comuns

- **"Não foi possível conectar ao servidor"** → o backend não está rodando,
  ou está rodando em outra porta. Confirme em `api_config.dart` se a porta
  bate com a do `.env` do backend (padrão: 3000).
- **Erro de CORS no console do Chrome** → não deveria acontecer, pois o
  backend já tem `app.use(cors())`. Se acontecer, confirme que está usando
  o `server.js` mais recente do backend.
- **"A senha deve conter pelo menos um número"** → essa validação já existe
  no `ValidadorAuth` do projeto (não foi alterada); é regra do CT04, não bug.

## ➡️ Próximo passo depois disso

Com login/cadastro funcionando de ponta a ponta, o próximo passo natural é
guardar o token nas próximas chamadas (ex: ao buscar dados do `Pet` ou
salvar um registro emocional) usando `SessionManager.obterToken()` no
header `Authorization: Bearer <token>`.
