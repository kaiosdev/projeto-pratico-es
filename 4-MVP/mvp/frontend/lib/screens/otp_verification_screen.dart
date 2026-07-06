import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../src/utils/validador_auth.dart'; // Importação corrigida com src
import '../src/services/auth_service.dart'; // Importação necessária para o AuthService
import 'home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 900; 
  Timer? _timer;

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
        }
      }
    });
  }

  String get _timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O código deve ter 6 dígitos.'), backgroundColor: Colors.orange),
      );
      return;
    }

    final expiraEm = DateTime.now().add(Duration(seconds: _secondsRemaining));

    final erro = ValidadorAuth.validarCodigoVerificacao(
      codigoDigitado: _otpController.text,
      codigoEsperado: "123456", // Mock para teste, substituir por lógica de backend
      expiraEm: expiraEm,
    );

    if (erro != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    } else {
      bool sucesso = await AuthService.verificarCodigo(
        email: widget.email, 
        codigo: _otpController.text
      );

      if (!mounted) return;
      if (sucesso) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código incorreto.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0A0),
      appBar: AppBar(
        title: const Text("Verificação", style: TextStyle(color: kDark)),
        backgroundColor: kYellow,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Enviamos um código para ${widget.email}", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, letterSpacing: 8, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: "000000"),
            ),
            
            const SizedBox(height: 20),
            Text("Expira em: $_timerText", style: const TextStyle(fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 40),
            // REMOVIDO "const" DESTE BOTÃO
            ElevatedButton(
              onPressed: _secondsRemaining > 0 ? _verifyOtp : null,
              child: const Text("VALIDAR CÓDIGO"),
            ),
            
            // REMOVIDO "const" DESTE BOTÃO
            TextButton(
              onPressed: _secondsRemaining == 0 ? () {
                setState(() => _secondsRemaining = 900);
                _startTimer();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código reenviado!')));
              } : null,
              child: const Text("Reenviar código"),
            ),
          ],
        ),
      ),
    );
  }
}