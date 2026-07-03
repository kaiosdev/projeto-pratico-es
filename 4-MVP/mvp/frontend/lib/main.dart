import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';

void main() async {
  // Garante que os bindings nativos estejam prontos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as chaves que o CLI acabou de gerar
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ProviderScope injeta o Riverpod para o gerenciamento de estado
  runApp(const ProviderScope(child: SlowDownApp()));
}

class SlowDownApp extends StatelessWidget {
  const SlowDownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SlowDown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5C842),
      ),
      home: const SplashScreen(),
    );
  }
}