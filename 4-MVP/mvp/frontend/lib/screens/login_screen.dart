import 'package:flutter/material.dart';
import 'package:slowdown/screens/register_screen.dart';

import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  // Paleta SlowDown
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kOrange = Color(0xFFF0A500);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha e-mail e senha.'),
          backgroundColor: kDark,
        ),
      );
      return;
    }

    // TODO: Integrar com Firebase Auth (US-16)
    debugPrint('Login local: $email');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _handleGoogleLogin() {
    // TODO: Integrar com Google OAuth (US-16 / Persona Ana)
    debugPrint('Iniciando Login via Google');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar customizada
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuScreen())),
                      child: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Conteúdo com gradiente
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
                      const SizedBox(height: 48),
                      const _SlowDownLogo(size: 52),
                      const SizedBox(height: 40),

                      // Card laranja com formulário
                      Container(
                        decoration: BoxDecoration(
                          color: kOrange,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _InputField(
                              controller: _emailController,
                              hintText: 'E-mail',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            _InputField(
                              controller: _passwordController,
                              hintText: 'Senha',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            const SizedBox(height: 12),

                            // Lembrar-me + Esqueci a Senha
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: _rememberMe ? kDark : Colors.white.withOpacity(0.85),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                                        ),
                                        child: _rememberMe ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Lembrar-me', style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                                  child: const Text(
                                    'Esqueci a Senha',
                                    style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Botão LOGIN
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                ),
                                child: const Text(
                                  'ENTRAR',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2, color: kDark),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Botão Google OAuth (US-16 / AC1)
                            SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: _handleGoogleLogin,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                ),
                                icon: const Icon(Icons.g_mobiledata_rounded, color: Colors.white, size: 32),
                                label: const Text(
                                  'Continuar com Google',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Não tem conta?
                            Column(
                              children: [
                                const Text('Ainda não possui uma conta?', style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                                  child: const Text(
                                    'Criar minha conta',
                                    style: TextStyle(color: kDark, fontSize: 14, fontWeight: FontWeight.w800, decoration: TextDecoration.underline),
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
          child: Text('SLOW', style: TextStyle(color: const Color(0xFFF5B800), fontSize: size * 0.45, fontWeight: FontWeight.w900, height: 1)),
        ),
        SizedBox(width: size * 0.08),
        Text('DOWN', style: TextStyle(color: const Color(0xFF1C1C1C), fontSize: size * 0.72, fontWeight: FontWeight.w900, height: 1)),
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
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
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