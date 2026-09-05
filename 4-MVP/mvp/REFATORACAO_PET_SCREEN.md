# Refatorações Simples no Frontend

## Refatoração 1 — Estado da Tela do Pet

### Problema Identificado
No arquivo [frontend/lib/screens/pet_screen.dart](frontend/lib/screens/pet_screen.dart), o controle da exibição dos fogos de artifício estava sendo feito com um nome de variável inconsistente. Isso gerava confusão na leitura do código e dificultava a manutenção, pois o estado parecia existir em um lugar diferente do que realmente era usado.

### Motivação da Refatoração
A refatoração foi necessária para deixar o código mais claro e consistente. Ao padronizar o nome do estado, o fluxo de execução fica mais fácil de entender e futuras alterações passam a ser menos propensas a erros.

### Descrição da Melhoria
Foi ajustado o nome do estado responsável por mostrar os fogos de artifício para um identificador mais claro e consistente.

#### Antes
```dart
bool _showFireworks = false;

void _showFireworks() {
  setState(() => _showFireworks = true);
  _fireworkController.forward(from: 0).then((_) {
    if (mounted) setState(() => _showFireworks = false);
  });
}
```

#### Depois
```dart
bool _isShowingFireworks = false;

void _showFireworks() {
  setState(() => _isShowingFireworks = true);
  _fireworkController.forward(from: 0).then((_) {
    if (mounted) setState(() => _isShowingFireworks = false);
  });
}
```

### Impacto no Sistema
Essa mudança melhora a legibilidade e reduz o risco de erros de manutenção. O código ficou mais intuitivo, facilitando futuras refatorações e evoluções da tela do pet.

---

## Refatoração 2 — Organização da Tela de Login

### Problema Identificado
No arquivo [frontend/lib/screens/login_screen.dart](frontend/lib/screens/login_screen.dart), o método responsável por tratar o login acumulava a validação e o feedback em um único fluxo, o que deixava o código mais longo do que o necessário.

### Motivação da Refatoração
A refatoração foi feita para simplificar a leitura do método principal e deixar a responsabilidade do código mais clara. Com isso, a manutenção fica mais fácil e o fluxo de execução se torna mais direto.

### Descrição da Melhoria
Foi separada a validação do formulário e a exibição de feedback em métodos menores e mais objetivos.

#### Antes
```dart
Future<void> _handleLogin() async {
  final emailErr = _validateEmail();
  final passErr = _validatePassword();

  final firstError = emailErr ?? passErr;

  if (firstError != null) {
    _showSnackBar(firstError, isError: true);
    return;
  }
}
```

#### Depois
```dart
String? _validateLoginForm() {
  return _validateEmail() ?? _validatePassword();
}

Future<void> _handleLogin() async {
  final validationError = _validateLoginForm();

  if (validationError != null) {
    _showFeedback(validationError, isError: true);
    return;
  }
}
```

### Impacto no Sistema
Essa mudança melhora a organização do código, reduz a repetição de lógica e deixa a tela de login mais fácil de entender e evoluir.

---

## Refatoração 3 — Campos de Entrada da Tela de Login

### Problema Identificado
No arquivo [frontend/lib/screens/login_screen.dart](frontend/lib/screens/login_screen.dart), os campos de e-mail e senha compartilham o mesmo estilo visual, mas estavam sendo construídos diretamente no corpo da tela, o que aumentava a repetição de código.

### Motivação da Refatoração
A refatoração foi feita para reduzir a duplicação de estrutura e deixar a tela mais simples de manter. Ao separar a lógica de cada campo em widgets menores, o código fica mais limpo e mais fácil de evoluir.

### Descrição da Melhoria
Foi criado um widget base para o campo de entrada e widgets específicos para e-mail e senha.

#### Antes
```dart
_InputField(
  controller: _emailController,
  hintText: 'Email',
  prefixIcon: Icons.person_outline_rounded,
  keyboardType: TextInputType.emailAddress,
),

_InputField(
  controller: _passwordController,
  hintText: 'Senha',
  prefixIcon: Icons.lock_outline_rounded,
  obscureText: _obscurePassword,
  suffixIcon: _obscurePassword
      ? Icons.visibility_off_outlined
      : Icons.visibility_outlined,
  onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
),
```

#### Depois
```dart
_EmailInputField(controller: _emailController),

_PasswordInputField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
),
```

### Impacto no Sistema
Essa mudança melhora a legibilidade e reduz a repetição de código, deixando a tela de login mais organizada e preparada para futuras alterações.

---

## Refatoração 4 — Campos de Entrada da Tela de Cadastro

### Problema Identificado
No arquivo [frontend/lib/screens/register_screen.dart](frontend/lib/screens/register_screen.dart), os campos de nome, e-mail, senha e confirmação de senha compartilhavam a mesma estrutura visual, mas estavam sendo declarados diretamente no corpo da tela, o que aumentava a repetição de código.

### Motivação da Refatoração
A refatoração foi feita para reduzir a duplicação de estrutura e deixar a tela mais simples de manter. Com widgets menores para cada tipo de campo, o código fica mais limpo e mais fácil de evoluir.

### Descrição da Melhoria
Foi criado um widget base para os campos de entrada e widgets específicos para nome, e-mail, senha e confirmação de senha.

#### Antes
```dart
_InputField(
  controller: _nameController,
  hintText: 'Nome completo',
  prefixIcon: Icons.person_outline_rounded,
  keyboardType: TextInputType.name,
  textCapitalization: TextCapitalization.words,
),

_InputField(
  controller: _emailController,
  hintText: 'Email',
  prefixIcon: Icons.email_outlined,
  keyboardType: TextInputType.emailAddress,
),
```

#### Depois
```dart
_NameInputField(controller: _nameController),

_EmailInputField(controller: _emailController),
```

### Impacto no Sistema
Essa mudança melhora a legibilidade da tela de cadastro, reduz a repetição de código e facilita futuras alterações no formulário.

---

## Refatoração 5 — Botão Principal da Tela de Cadastro

### Problema Identificado
No arquivo [frontend/lib/screens/register_screen.dart](frontend/lib/screens/register_screen.dart), o botão principal de cadastro estava embutido diretamente no corpo da tela, misturando a lógica de layout com a estrutura do formulário.

### Motivação da Refatoração
A refatoração foi feita para separar a responsabilidade visual do botão e deixar o código mais limpo e reutilizável.

### Descrição da Melhoria
Foi criado um widget próprio para o botão principal, permitindo que a tela use um componente mais simples e com uma leitura melhor.

#### Antes
```dart
SizedBox(
  height: 52,
  child: ElevatedButton(
    onPressed: isLoading ? null : _handleRegister,
    ...
  ),
),
```

#### Depois
```dart
_PrimaryActionButton(
  isLoading: isLoading,
  onPressed: _handleRegister,
  label: 'CRIAR CONTA',
),
```

### Impacto no Sistema
Essa mudança melhora a organização da tela, facilita a reutilização do botão e deixa o formulário mais legível.

---

## Refatoração 6 — Organização da Tela de Meditação

### Problema Identificado
No arquivo [frontend/lib/screens/meditation_screen.dart](frontend/lib/screens/meditation_screen.dart), a construção da tela principal acumulava em um único bloco grande parte da estrutura visual, o que deixava o método build mais longo e mais difícil de ler.

### Motivação da Refatoração
A refatoração foi feita para organizar melhor o código sem alterar o comportamento da tela. Ao separar trechos do layout em métodos menores, a leitura do arquivo fica mais simples e a manutenção fica mais tranquila.

### Descrição da Melhoria
Foram extraídos para métodos privados os blocos responsáveis por:
- o app bar da tela;
- o cabeçalho com a mensagem de introdução;
- a lista de sessões disponíveis.

#### Antes
O método build continha grande parte do layout diretamente, incluindo a barra superior, o cabeçalho e a lista.

#### Depois
O build passou a chamar métodos menores, como:
```dart
_buildAppBar(context),
_buildHeader(),
_buildSessionList(context),
```

### Impacto no Sistema
Essa mudança melhora a organização do código, deixa a tela mais fácil de entender e facilita futuras alterações no layout sem mexer no comportamento existente.

---

## Refatoração 7 — Organização da Tela de Acessibilidade

### Problema Identificado
No arquivo [frontend/lib/accessibility_screen.dart](frontend/lib/accessibility_screen.dart), a lógica de animação do ícone de voz e o controle do estado do toggle ficaram misturados diretamente no build da tela, o que deixava o código mais extenso e menos claro.

### Motivação da Refatoração
A refatoração foi feita para separar a lógica de controle visual em métodos menores, sem alterar o comportamento da tela.

### Descrição da Melhoria
Foram extraídos para métodos privados:
- a atualização da animação do ícone de voz;
- a construção do ícone de voz;
- a construção do toggle de voz.

#### Antes
A animação e o toggle estavam diretamente dentro do build, junto com o restante da tela.

#### Depois
A lógica passou a ficar em métodos como:
```dart
void _updateVoiceAnimation(bool isEnabled) {
  if (isEnabled) {
    _iconController.repeat(reverse: true);
  } else {
    _iconController.stop();
    _iconController.reset();
  }
}

Widget _buildVoiceIcon() {
  return ScaleTransition(...);
}

Widget _buildVoiceToggle() {
  return GestureDetector(...);
}
```

### Impacto no Sistema
Essa mudança melhora a organização da tela, deixa o fluxo de animação e toggle mais fácil de ler e facilita futuras alterações visuais sem mexer na lógica principal.
