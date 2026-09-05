import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/providers/auth_provider.dart';
import '../src/utils/validador_auth.dart'; 
import '../src/services/auth_service.dart'; // Import do Serviço de Autenticação
import 'login_screen.dart';
import 'otp_verification_screen.dart';
import 'home_screen.dart'; // Import da HomeScreen para o redirecionamento do Google

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
  bool _isLoadingGoogle = false; // Novo estado para o loading do Google

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

  // ─── Validações Integradas com ValidadorAuth (US-16) ──────────────────────
  String? _validateConfirm() {
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  String? _validateRegisterForm() {
    return ValidadorAuth.validarNome(_nameController.text) ?? 
           ValidadorAuth.validarEmail(_emailController.text) ?? 
           ValidadorAuth.validarSenha(_passwordController.text) ?? 
           _validateConfirm();
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
      
      _showSnackBar('Quase lá! Verifique seu e-mail.', isError: false);
      
      // Implementação da US-16: Redirecionamento para a tela de OTP
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(email: _emailController.text.trim()),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString(), isError: true);
    }
  }
  
  // ─── Lógica do Google Atualizada ──────────────────────────
  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoadingGoogle = true);

    try {
      final result = await AuthService.loginComGoogle();
      
      if (!mounted) return;

      if (result.sucesso) {
        // Redireciona direto para a Home, dispensando OTP
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _showSnackBar(result.mensagemErro ?? 'Erro ao cadastrar com Google', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoadingGoogle = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? kError : Colors.green,
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
                    const SizedBox(width: 40),
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
                          fontWeight: FontWeight.w600,
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
                            
                            // Termos de Uso
                            GestureDetector(
                              onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
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
                                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: kDark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          height: 1.4,
                                        ),
                                        children: [
                                          TextSpan(text: 'Concordo com os '),
                                          TextSpan(
                                            text: 'Termos de Uso',
                                            style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w800),
                                          ),
                                          TextSpan(text: ' e a '),
                                          TextSpan(
                                            text: 'Política de Privacidade',
                                            style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w800),
                                          ),
                                          TextSpan(text: '.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Botão Cadastrar
                            _PrimaryActionButton(
                              isLoading: isLoading,
                              onPressed: _handleRegister,
                              label: 'CRIAR CONTA',
                            ),
                            const SizedBox(height: 16),
                            
                            // Botão Google Atualizado
                            SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: _isLoadingGoogle || isLoading ? null : _handleGoogleRegister,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  disabledForegroundColor: Colors.white.withOpacity(0.5),
                                ),
                                icon: _isLoadingGoogle
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Icon(Icons.g_mobiledata_rounded, color: Colors.white, size: 32),
                                label: Text(
                                  _isLoadingGoogle ? 'Conectando...' : 'Criar com Google',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Fazer Login
                            Column(
                              children: [
                                const Text(
                                  'Já possui uma conta?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  ),
                                  child: const Text(
                                    'Fazer Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
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
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Color(0xFF1C1C1C),
                ),
              ),
      ),
    );
  }
}

// ─── Widgets Auxiliares Mantidos ──────────────────────────────────────────────
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
        style: const TextStyle(color: Color(0xFF1C1C1C), fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w400),
          prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600, size: 22),
          suffixIcon: suffixIcon != null ? GestureDetector(onTap: onSuffixTap, child: Icon(suffixIcon, color: Colors.grey.shade600, size: 20)) : null,
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
      hintText: 'E-mail',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  const _PasswordInputField({required this.controller, required this.obscureText, this.onToggleVisibility});
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
  const _ConfirmPasswordInputField({required this.controller, required this.obscureText, this.onToggleVisibility});
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