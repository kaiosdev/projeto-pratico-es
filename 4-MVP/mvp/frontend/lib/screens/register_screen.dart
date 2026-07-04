import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/providers/auth_provider.dart';
import 'home_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;

  // Paleta SlowDown
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kOrange = Color(0xFFF0A500);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kError = Color(0xFFD32F2F);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validações
  String? _validateName() {
    if (_nameController.text.trim().isEmpty) return 'Informe seu nome.';
    return null;
  }

  String? _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return 'Informe seu e-mail.';
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      return 'E-mail inválido.';
    }
    return null;
  }

  String? _validatePassword() {
    if (_passwordController.text.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }
    return null;
  }

  String? _validateConfirm() {
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  String? _validateRegisterForm() {
    return _validateName() ?? _validateEmail() ?? _validatePassword() ?? _validateConfirm();
  }

  Future<void> _handleRegister() async {
    final validationError = _validateRegisterForm();

    if (validationError != null) {
      _showSnackBar(validationError, isError: true);
      return;
    }

    if (!_acceptTerms) {
      _showSnackBar('Aceite os termos para continuar.', isError: true);
      return;
    }

    try {
      // Chamada real ao Riverpod + Firebase + Node.js
      await ref.read(authNotifierProvider.notifier).registar(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      _showSnackBar('Conta criada com sucesso!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString(), isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? kError : kDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o estado global para controlar o loading do botão
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Column(
        children: [
          // ── AppBar ──────────────────────────────────────────────────────
          Container(
            color: kYellow,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.reply_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const _SlowDownLogo(size: 28),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Corpo ────────────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBgTop, kBgBottom],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const _SlowDownLogo(size: 48),
                      const SizedBox(height: 6),
                      Text(
                        'Crie sua conta',
                        style: TextStyle(
                          color: kDark.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Card do formulário ─────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: kOrange,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _NameInputField(controller: _nameController),
                            const SizedBox(height: 14),
                            _EmailInputField(controller: _emailController),
                            const SizedBox(height: 14),
                            _PasswordInputField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            const SizedBox(height: 14),
                            _ConfirmPasswordInputField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirm,
                              onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(top: 1),
                                    decoration: BoxDecoration(
                                      color: _acceptTerms ? kDark : Colors.white.withOpacity(0.85),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: _acceptTerms
                                        ? const Icon(Icons.check, color: Colors.white, size: 13)
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: kDark,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w500,
                                          height: 1.4,
                                        ),
                                        children: [
                                          TextSpan(text: 'Concordo com os '),
                                          TextSpan(
                                            text: 'Termos de Uso',
                                            style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(text: ' e a '),
                                          TextSpan(
                                            text: 'Política de Privacidade',
                                            style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(text: '.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            _PrimaryActionButton(
                              isLoading: isLoading,
                              onPressed: _handleRegister,
                              label: 'CRIAR CONTA',
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                const Text(
                                  'Já tem uma conta?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).maybePop(),
                                  child: const Text(
                                    'Fazer login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;

  const _PrimaryActionButton({
    required this.isLoading,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1C1C1C),
          disabledBackgroundColor: Colors.white.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF1C1C1C)),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                  color: Color(0xFF1C1C1C),
                ),
              ),
      ),
    );
  }
}

// ─── Widget: Logo SlowDown ────────────────────────────────────────────────────
class _SlowDownLogo extends StatelessWidget {
  final double size;
  const _SlowDownLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.14, vertical: size * 0.08),
          decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(4)),
          child: Text(
            'SLOW',
            style: TextStyle(color: const Color(0xFFF5B800), fontSize: size * 0.45, fontWeight: FontWeight.w900, letterSpacing: 0.5, height: 1),
          ),
        ),
        SizedBox(width: size * 0.08),
        Text(
          'DOWN',
          style: TextStyle(color: const Color(0xFF1C1C1C), fontSize: size * 0.72, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1),
        ),
      ],
    );
  }
}

// ─── Widget: Campo de Input ───────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: const TextStyle(color: Color(0xFF1C1C1C), fontSize: 15, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500, size: 22),
          suffixIcon: suffixIcon != null ? GestureDetector(onTap: onSuffixTap, child: Icon(suffixIcon, color: Colors.grey.shade400, size: 20)) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}

class _NameInputField extends StatelessWidget {
  final TextEditingController controller;

  const _NameInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _InputField(
      controller: controller,
      hintText: 'Nome completo',
      prefixIcon: Icons.person_outline_rounded,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
    );
  }
}

class _EmailInputField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _InputField(
      controller: controller,
      hintText: 'Email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const _PasswordInputField({
    required this.controller,
    required this.obscureText,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return _InputField(
      controller: controller,
      hintText: 'Senha',
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: obscureText,
      suffixIcon: obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      onSuffixTap: onToggleVisibility,
    );
  }
}

class _ConfirmPasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const _ConfirmPasswordInputField({
    required this.controller,
    required this.obscureText,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return _InputField(
      controller: controller,
      hintText: 'Confirmar senha',
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: obscureText,
      suffixIcon: obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      onSuffixTap: onToggleVisibility,
    );
  }
}