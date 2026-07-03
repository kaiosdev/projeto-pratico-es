import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  // Paleta SlowDown
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kOrange = Color(0xFFF0A500);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kError = Color(0xFFD32F2F);

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleSendLink() async {
    final emailErr = _validateEmail();
    if (emailErr != null) {
      _showSnackBar(emailErr, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // TODO: integrar Firebase Auth
    // await FirebaseAuth.instance.sendPasswordResetEmail(
    //   email: _emailController.text.trim(),
    // );

    await Future.delayed(const Duration(seconds: 1)); // simula chamada
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });

    debugPrint('Reset enviado para: ${_emailController.text.trim()}');
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
    return Scaffold(
      body: Column(
        children: [
          // ── AppBar ──────────────────────────────────────────────────────
          Container(
            color: kYellow,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        child: const Icon(
                          Icons.reply_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    _SlowDownLogo(size: 28),
                    GestureDetector(
                      onTap: () {},
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

                      _SlowDownLogo(size: 48),

                      const SizedBox(height: 6),

                      Text(
                        'Recuperar senha',
                        style: TextStyle(
                          color: kDark.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Card ──────────────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: kOrange,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: _emailSent
                            ? _SuccessContent(
                                email: _emailController.text.trim(),
                                onBack: () =>
                                    Navigator.of(context).maybePop(),
                              )
                            : _FormContent(
                                emailController: _emailController,
                                isLoading: _isLoading,
                                onSend: _handleSendLink,
                                onBack: () =>
                                    Navigator.of(context).maybePop(),
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

// ─── Estado: Formulário ───────────────────────────────────────────────────────

class _FormContent extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onBack;

  static const Color kDark = Color(0xFF1C1C1C);

  const _FormContent({
    required this.emailController,
    required this.isLoading,
    required this.onSend,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ícone de cadeado
        Container(
          width: 64,
          height: 64,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),

        // Instrução
        const Text(
          'Informe o e-mail cadastrado e enviaremos um link para você redefinir sua senha.',
          style: TextStyle(
            color: kDark,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        // Campo e-mail
        _InputField(
          controller: emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 22),

        // Botão ENVIAR LINK
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSend,
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
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: kDark,
                    ),
                  )
                : const Text(
                    'ENVIAR LINK',
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

        // Voltar ao login
        Column(
          children: [
            const Text(
              'Lembrou a senha?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            GestureDetector(
              onTap: onBack,
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
    );
  }
}

// ─── Estado: Sucesso ──────────────────────────────────────────────────────────

class _SuccessContent extends StatelessWidget {
  final String email;
  final VoidCallback onBack;

  static const Color kDark = Color(0xFF1C1C1C);

  const _SuccessContent({required this.email, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ícone de sucesso
        Container(
          width: 64,
          height: 64,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),

        // Mensagem de confirmação
        const Text(
          'Link enviado!',
          style: TextStyle(
            color: kDark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: kDark,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Enviamos um link de redefinição para '),
              TextSpan(
                text: email,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const TextSpan(
                  text: '. Verifique também sua caixa de spam.'),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Botão VOLTAR AO LOGIN
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: kDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text(
              'VOLTAR AO LOGIN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: kDark,
              ),
            ),
          ),
        ),
      ],
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
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
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