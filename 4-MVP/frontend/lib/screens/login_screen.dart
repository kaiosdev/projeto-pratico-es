import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/providers/auth_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kOrange = Color(0xFFF0A500);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kError = Color(0xFFD32F2F);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    if (_passwordController.text.isEmpty) return 'Informe sua senha.';
    return null;
  }

  Future<void> _handleLogin() async {
    final emailErr = _validateEmail();
    final passErr = _validatePassword();

    final firstError = emailErr ?? passErr;

    if (firstError != null) {
      _showSnackBar(firstError, isError: true);
      return;
    }

    try {
      await ref.read(authNotifierProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      _showSnackBar('Login realizado com sucesso!');
      
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
                    Container(width: 40), // Espaçador para simetria
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
                      const SizedBox(height: 50),
                      const _SlowDownLogo(size: 48),
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
                            _InputField(
                              controller: _emailController,
                              hintText: 'Email',
                              prefixIcon: Icons.person_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),
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
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: _rememberMe ? kDark : Colors.white.withOpacity(0.85),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: _rememberMe
                                            ? const Icon(Icons.check, color: Colors.white, size: 12)
                                            : null,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Remember Me',
                                        style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: kDark,
                                  disabledBackgroundColor: Colors.white.withOpacity(0.5),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(strokeWidth: 2.5, color: kDark),
                                      )
                                    : const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2.5,
                                          color: kDark,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 2),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                    );
                                  },
                                  child: const Text(
                                    'Create an account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
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