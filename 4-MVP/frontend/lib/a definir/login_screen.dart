import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'menu_screen.dart';
import 'home_screen.dart';

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
                    // Botão voltar
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.reply_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),

                    // Logo no centro
                    _SlowDownLogo(size: 28),

                    // Menu hamburguer
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MenuScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
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

                      // Logo grande
                      _SlowDownLogo(size: 52),

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
                            // Campo Email
                            _InputField(
                              controller: _emailController,
                              hintText: 'Email',
                              prefixIcon: Icons.person_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 16),

                            // Campo Senha
                            _InputField(
                              controller: _passwordController,
                              hintText: 'Password',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              onSuffixTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            // Remember Me + Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _rememberMe = !_rememberMe;
                                        });
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: _rememberMe
                                              ? kDark
                                              : Colors.white.withOpacity(0.85),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.6),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: _rememberMe
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 13,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        color: kDark,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: kDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Botão LOGIN
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: kDark,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.5,
                                    color: kDark,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Don't have an account?
                            Column(
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Create an account',
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

  void _handleLogin() {
    // TODO: integrar com Firebase Auth
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha email e senha.'),
          backgroundColor: Color(0xFF1C1C1C),
        ),
      );
      return;
    }

    // Navegar para a HomeScreen após autenticação
    debugPrint('Login: $email');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.14,
            vertical: size * 0.08,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'SLOW',
            style: TextStyle(
              color: const Color(0xFFF5B800),
              fontSize: size * 0.45,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              height: 1,
            ),
          ),
        ),
        SizedBox(width: size * 0.08),
        Text(
          'DOWN',
          style: TextStyle(
            color: const Color(0xFF1C1C1C),
            fontSize: size * 0.72,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1,
          ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF1C1C1C),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey.shade500,
            size: 22,
          ),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    suffixIcon,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}