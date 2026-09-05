<div align="center">
  <h1 style="color: #2e7d32;"> REFATORAÇÕES </h1>
  <p><i>Engenharia de Software A - ICET/UFAM</i></p>

  <br>

  | Campo | Informação |
  |:---|:---|
  | **Nome do Projeto** | SlowDown |
  | **Responsável** | Evelly Rebeca |
  | **Coordenador** | Prof. Dr. Andrey Rodrigues |

</div>

---

## 1. Refatoração — Estado da Tela do Pet

### 1.1 Problema Identificado

<div align="justify">

No arquivo [frontend/lib/screens/pet_screen.dart](frontend/lib/screens/pet_screen.dart), o controle da exibição dos fogos de artifício estava sendo feito com um nome de variável inconsistente. Isso gerava confusão na leitura do código e dificultava a manutenção, pois o estado parecia existir em um lugar diferente do que realmente era usado.

</div>

### 1.2 Motivação da Refatoração

<div align="justify">

A refatoração foi necessária para deixar o código mais claro e consistente. Ao padronizar o nome do estado, o fluxo de execução fica mais fácil de entender e futuras alterações passam a ser menos propensas a erros.

</div>

### 1.3 Descrição da Melhoria

<div align="justify">

Foi ajustado o nome do estado responsável por mostrar os fogos de artifício para um identificador mais claro e consistente.

</div>

**Antes**
```dart
bool _showFireworks = false;

void _showFireworks() {
  setState(() => _showFireworks = true);
  _fireworkController.forward(from: 0).then((_) {
    if (mounted) setState(() => _showFireworks = false);
  });
}
```

**Depois**
```dart
bool _isShowingFireworks = false;

void _showFireworks() {
  setState(() => _isShowingFireworks = true);
  _fireworkController.forward(from: 0).then((_) {
    if (mounted) setState(() => _isShowingFireworks = false);
  });
}
```

### 1.4 Impacto no Sistema

<div align="justify">

Essa mudança melhora a legibilidade e reduz o risco de erros de manutenção. O código ficou mais intuitivo, facilitando futuras refatorações e evoluções da tela do pet.

</div>

---

## 2. Refatoração — Organização da Tela de Login

### 2.1 Problema Identificado

<div align="justify">

No arquivo [frontend/lib/screens/login_screen.dart](frontend/lib/screens/login_screen.dart), o método responsável por tratar o login acumulava a validação e o feedback em um único fluxo, o que deixava o código mais longo do que o necessário.

</div>

### 2.2 Motivação da Refatoração

<div align="justify">

A refatoração foi feita para simplificar a leitura do método principal e deixar a responsabilidade do código mais clara. Com isso, a manutenção fica mais fácil e o fluxo de execução se torna mais direto.

</div>

### 2.3 Descrição da Melhoria

<div align="justify">

Foi separada a validação do formulário e a exibição de feedback em métodos menores e mais objetivos.

</div>

**Antes**
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

**Depois**
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

### 2.4 Impacto no Sistema

<div align="justify">

Essa mudança melhora a organização do código, reduz a repetição de lógica e deixa a tela de login mais fácil de entender e evoluir.

</div>

---

## 3. Refatoração — Campos de Entrada da Tela de Login

### 3.1 Problema Identificado

<div align="justify">

No arquivo [frontend/lib/screens/login_screen.dart](frontend/lib/screens/login_screen.dart), os campos de e-mail e senha compartilham o mesmo estilo visual, mas estavam sendo construídos diretamente no corpo da tela, o que aumentava a repetição de código.

</div>

### 3.2 Motivação da Refatoração

<div align="justify">

A refatoração foi feita para reduzir a duplicação de estrutura e deixar a tela mais simples de manter. Ao separar a lógica de cada campo em widgets menores, o código fica mais limpo e mais fácil de evoluir.

</div>

### 3.3 Descrição da Melhoria

<div align="justify">

Foi criado um widget base para o campo de entrada e widgets específicos para e-mail e senha.

</div>

**Antes**
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

**Depois**
```dart
_EmailInputField(controller: _emailController),

_PasswordInputField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
),
```

### 3.4 Impacto no Sistema

<div align="justify">

Essa mudança melhora a legibilidade e reduz a repetição de código, deixando a tela de login mais organizada e preparada para futuras alterações.

</div>

---

## 4. Refatoração — Campos de Entrada da Tela de Cadastro

### 4.1 Problema Identificado

<div align="justify">

No arquivo [frontend/lib/screens/register_screen.dart](frontend/lib/screens/register_screen.dart), os campos de nome, e-mail, senha e confirmação de senha compartilhavam a mesma estrutura visual, mas estavam sendo declarados diretamente no corpo da tela, o que aumentava a repetição de código.

</div>

### 4.2 Motivação da Refatoração

<div align="justify">

A refatoração foi feita para reduzir a duplicação de estrutura e deixar a tela mais simples de manter. Com widgets menores para cada tipo de campo, o código fica mais limpo e mais fácil de evoluir.

</div>

### 4.3 Descrição da Melhoria

<div align="justify">

Foi criado um widget base para os campos de entrada e widgets específicos para nome, e-mail, senha e confirmação de senha.

</div>

**Antes**
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

**Depois**
```dart
_NameInputField(controller: _nameController),

_EmailInputField(controller: _emailController),
```

### 4.4 Impacto no Sistema

<div align="justify">

Essa mudança melhora a legibilidade da tela de cadastro, reduz a repetição de código e facilita futuras alterações no formulário.

</div>

---

## 5. Refatoração — Botão Principal da Tela de Cadastro

### 5.1 Problema Identificado

<div align="justify">

No arquivo [frontend/lib/screens/register_screen.dart](frontend/lib/screens/register_screen.dart), o botão principal de cadastro estava embutido diretamente no corpo da tela, misturando a lógica de layout com a estrutura do formulário.

</div>

### 5.2 Motivação da Refatoração

<div align="justify">

A refatoração foi feita para separar a responsabilidade visual do botão e deixar o código mais limpo e reutilizável.

</div>

### 5.3 Descrição da Melhoria

<div align="justify">

Foi criado um widget próprio para o botão principal, permitindo que a tela use um componente mais simples e com uma leitura melhor.

</div>

**Antes**
```dart
SizedBox(
  height: 52,
  child: ElevatedButton(
    onPressed: isLoading ? null : _handleRegister,
    ...
  ),
),
```

**Depois**
```dart
_PrimaryActionButton(
  isLoading: isLoading,
  onPressed: _handleRegister,
  label: 'CRIAR CONTA',
),
```

### 5.4 Impacto no Sistema

<div align="justify">

Essa mudança melhora a organização da tela, facilita a reutilização do botão e deixa o formulário mais legível.

</div>

---

## 6. Refatoração — Organização da Tela de Meditação

### 6.1 Problema Identificado

<div align="justify">

No arquivo [frontend/lib/screens/meditation_screen.dart](frontend/lib/screens/meditation_screen.dart), a construção da tela principal acumulava em um único bloco grande parte da estrutura visual, o que deixava o método build mais longo e mais difícil de ler.

</div>

### 6.2 Motivação da Refatoração

<div align="justify">

A refatoração foi feita para organizar melhor o código sem alterar o comportamento da tela. Ao separar trechos do layout em métodos menores, a leitura do arquivo fica mais simples e a manutenção fica mais tranquila.

</div>

### 6.3 Descrição da Melhoria

<div align="justify">

Foram extraídos para métodos privados os blocos responsáveis por:

</div>

- o app bar da tela;
- o cabeçalho com a mensagem de introdução;
- a lista de sessões disponíveis.

**Antes**

<div align="justify">

O método build continha grande parte do layout diretamente, incluindo a barra superior, o cabeçalho e a lista.

</div>

**Depois**

<div align="justify">

O build passou a chamar métodos menores, como:

</div>

```dart
_buildAppBar(context),
_buildHeader(),
_buildSessionList(context),
```

### 6.4 Impacto no Sistema

<div align="justify">

Essa mudança melhora a organização do código, deixa a tela mais fácil de entender e facilita futuras alterações no layout sem mexer no comportamento existente.

</div>

---

## 7. Refatoração — Organização da Tela de Acessibilidade

### 7.1 Problema Identificado

<div align="justify">

No arquivo [frontend/lib/accessibility_screen.dart](frontend/lib/accessibility_screen.dart), a lógica de animação do ícone de voz e o controle do estado do toggle ficaram misturados diretamente no build da tela, o que deixava o código mais extenso e menos claro.

</div>

### 7.2 Motivação da Refatoração

<div align="justify">

A refatoração foi feita para separar a lógica de controle visual em métodos menores, sem alterar o comportamento da tela.

</div>

### 7.3 Descrição da Melhoria

<div align="justify">

Foram extraídos para métodos privados:

</div>

- a atualização da animação do ícone de voz;
- a construção do ícone de voz;
- a construção do toggle de voz.

**Antes**

<div align="justify">

A animação e o toggle estavam diretamente dentro do build, junto com o restante da tela.

</div>

**Depois**

<div align="justify">

A lógica passou a ficar em métodos como:

</div>

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

### 7.4 Impacto no Sistema

<div align="justify">

Essa mudança melhora a organização da tela, deixa o fluxo de animação e toggle mais fácil de ler e facilita futuras alterações visuais sem mexer na lógica principal.

</div>

---

<div align="center">

  <sub>Desenvolvido para a disciplina de Engenharia de Software  · ICET/UFAM</sub>

</div>
