import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/validador_auth.dart';
import 'home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email; // Para mostrar ao usuário onde o código foi enviado

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 900; // 15 minutos = 900 segundos
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
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  String get _timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _verifyOtp() {
    // Simulando um código esperado (viria do seu backend)
    const String codigoEsperado = "123456"; 
    final expiraEm = DateTime.now().add(Duration(seconds: _secondsRemaining));

    final erro = ValidadorAuth.validarCodigoVerificacao(
      codigoDigitado: _otpController.text,
      codigoEsperado: codigoEsperado,
      expiraEm: expiraEm,
    );

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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
            
            // Campo de entrada otimizado para IHC
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
            ElevatedButton(
              onPressed: _secondsRemaining > 0 ? _verifyOtp : null,
              child: const Text("VALIDAR CÓDIGO"),
            ),
            
            TextButton(
              onPressed: _secondsRemaining == 0 ? () {
                setState(() => _secondsRemaining = 900);
                _startTimer();
              } : null,
              child: const Text("Reenviar código"),
            ),
          ],
        ),
      ),
    );
  }
}