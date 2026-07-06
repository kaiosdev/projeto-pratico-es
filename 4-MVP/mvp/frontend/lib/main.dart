import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';

void main() async {
  // Garante que os bindings nativos estejam prontos antes de chamar código assíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // Abordagem definitiva: Tenta inicializar. Se já existir, ignora o erro silenciosamente.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase já estava inicializado. Ignorando erro: $e');
  }

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