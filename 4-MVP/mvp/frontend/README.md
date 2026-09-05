<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Riverpod-1A202C?style=for-the-badge&logo=dart&logoColor=white" alt="Riverpod">
  
  <h1>🧘 SlowDown App — Frontend</h1>
  <p><b>Aplicativo focado em bem-estar, registro emocional e gamificação em saúde, desenvolvido em Flutter.</b></p>
</div>

<hr>

## 📋 Sobre o Projeto
O **SlowDown** é a interface móvel (Frontend) de um ecossistema de saúde e bem-estar. O aplicativo consome uma API RESTful (Backend em Node.js) para gerenciar usuários, registros emocionais, autenticação em duas etapas (OTP) e persistência de dados.


## 🛠️ Ferramentas Necessárias

Para rodar este projeto na sua máquina, você precisará ter instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versão 3.10 ou superior)
- [Dart SDK](https://dart.dev/get-dart)
- Editor de código: [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)
- Um emulador configurado (Android/iOS) ou um dispositivo físico conectado.
- **O Backend do SlowDown:** O servidor Node.js precisa estar rodando localmente.


## 🔗 Conectando ao Backend e Banco de Dados

### Passo 1: Configurar a URL da API
Para o Flutter "enxergar" o backend, você deve configurar o IP do servidor no arquivo de configuração de rede.

1. Navegue até o arquivo: `lib/src/services/api_config.dart`.
2. Altere a variável `baseUrl` de acordo com o seu ambiente de teste:

```dart
class ApiConfig {
  // 📱 Para Emuladores Android (o emulador mapeia o localhost do seu PC para 10.0.2.2)
  static const String baseUrl = '[http://10.0.2.2:3000](http://10.0.2.2:3000)';

  // 🍎 Para Simuladores iOS ou Web
  // static const String baseUrl = 'http://localhost:3000';

  // ☁️ Para Produção (quando o backend estiver online)
  // static const String baseUrl = '[https://api.slowdown.com.br](https://api.slowdown.com.br)';
}
```
### Passo 2: Banco de Dados
A conexão com o banco de dados MySQL é de inteira responsabilidade do Backend. Certifique-se de que o projeto `slowdown-backend` esteja com o arquivo `.env` configurado corretamente e o servidor executando na porta `3000` (ou a porta que você configurou acima).

---

## 🚀 Como Executar o Projeto

Com as ferramentas instaladas e o Backend rodando, siga os passos abaixo no seu terminal:

**1. Clone o repositório:**
```bash
git clone [https://github.com/seu-usuario/slowdown-frontend.git](https://github.com/seu-usuario/slowdown-frontend.git)
cd slowdown-frontend
```

**2. Baixe as dependências do Flutter:**
```bash
flutter pub get
```

**3. Limpe o cache de builds anteriores (Recomendado):**
```bash
flutter clean
```

**4. Execute o aplicativo:**
Selecione o seu emulador no VS Code (canto inferior direito) ou rode diretamente no terminal:
```bash
flutter run
```

---

## 📁 Estrutura do Projeto

A arquitetura do projeto foi dividida para facilitar a manutenção e escalabilidade:

```text
lib/
 ┣ 📂 screens/       # Telas da interface (Login, Register, Home, OTP, etc.)
 ┣ 📂 src/
 ┃ ┣ 📂 providers/   # Gerenciadores de estado (Riverpod)
 ┃ ┣ 📂 services/    # Comunicação com a API (HTTP) e SharedPreferences
 ┃ ┗ 📂 utils/       # Classes utilitárias (ValidadorAuth, Máscaras, etc.)
 ┣ 📂 widgets/       # Componentes visuais reutilizáveis (Botões, Inputs customizados)
 ┗ 📜 main.dart      # Ponto de entrada do aplicativo
```

---

<div align="center">
  <sub>Desenvolvido para a disciplina de Engenharia de Software  · ICET/UFAM</sub>
</div>
