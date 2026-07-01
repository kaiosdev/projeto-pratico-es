// test/us16_register_screen_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

import '../lib/screens/register_screen.dart';

// ─── 🛡️ MOCK INDESTRUTÍVEL DO FIREBASE (NÍVEL DART) ───
// Isso intercepta a inicialização antes de chegar no sistema Pigeon/Android.
class MockFirebasePlatform extends FirebasePlatform {
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseApp();
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseApp();
  }
}

class MockFirebaseApp extends FirebaseAppPlatform {
  MockFirebaseApp()
      : super(
          defaultFirebaseAppName,
          const FirebaseOptions(
            apiKey: '123',
            appId: '123',
            messagingSenderId: '123',
            projectId: '123',
          ),
        );
}
// ────────────────────────────────────────────────────────

class _CasoCadastro {
  final String id;
  final String descricao;
  final String nome;
  final String email;
  final String senha;
  final String confirmarSenha;
  final bool aceitarTermos;
  final String? mensagemErroEsperada;

  const _CasoCadastro({
    required this.id,
    required this.descricao,
    required this.nome,
    required this.email,
    required this.senha,
    required this.confirmarSenha,
    this.aceitarTermos = true,
    required this.mensagemErroEsperada,
  });
}

Future<void> _preencherEEnviarCadastro(
  WidgetTester tester,
  _CasoCadastro caso,
) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: RegisterScreen()),
    ),
  );

  await tester.enterText(find.widgetWithText(TextField, 'Nome completo'), caso.nome);
  await tester.enterText(find.widgetWithText(TextField, 'Email'), caso.email);
  await tester.enterText(find.widgetWithText(TextField, 'Senha'), caso.senha);
  await tester.enterText(find.widgetWithText(TextField, 'Confirmar senha'), caso.confirmarSenha);

  if (caso.aceitarTermos) {
    final termosFinder = find.byWidgetPredicate(
      (widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains('Concordo com os'),
    );
    await tester.tap(termosFinder);
    await tester.pump();
  }

  await tester.tap(find.text('CRIAR CONTA'));
  await tester.pump();
}

void main() {
  // 🚀 INICIALIZA O MOCK FALSO ANTES DOS TESTES DA TELA
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    FirebasePlatform.instance = MockFirebasePlatform();
    await Firebase.initializeApp();
  });

  group('US-16 · RegisterScreen — teste de integração (widget test)', () {
    testWidgets('[CT01] Email válido + Senha válida → sem erro de validação',
        (tester) async {
      final caso = _CasoCadastro(
        id: 'CT01',
        descricao: 'Email válido → Aceito',
        nome: 'Carlos Lima',
        email: 'carlos.lima@gmail.com',
        senha: 'Carlos123',
        confirmarSenha: 'Carlos123',
        mensagemErroEsperada: null,
      );

      await _preencherEEnviarCadastro(tester, caso);

      expect(find.text('Informe seu e-mail.'), findsNothing);
      expect(find.text('E-mail inválido.'), findsNothing);
      expect(find.text('A senha deve ter no mínimo 6 caracteres.'), findsNothing);
    });

    testWidgets('[CT02] Email inválido → exibe mensagem de erro', (tester) async {
      final caso = _CasoCadastro(
        id: 'CT02',
        descricao: 'Email inválido → Rejeitado',
        nome: 'Carlos Lima',
        email: 'carlos.limagmail.com',
        senha: 'Carlos123',
        confirmarSenha: 'Carlos123',
        mensagemErroEsperada: 'E-mail inválido.',
      );

      await _preencherEEnviarCadastro(tester, caso);

      expect(find.text(caso.mensagemErroEsperada!), findsOneWidget);
    });

    testWidgets('[CT03] Senha válida → sem erro de validação', (tester) async {
      final caso = _CasoCadastro(
        id: 'CT03',
        descricao: 'Senha válida → Aceita',
        nome: 'Carlos Lima',
        email: 'carlos.lima@gmail.com',
        senha: 'Carlos123',
        confirmarSenha: 'Carlos123',
        mensagemErroEsperada: null,
      );

      await _preencherEEnviarCadastro(tester, caso);

      expect(find.text('A senha deve ter no mínimo 6 caracteres.'), findsNothing);
    });

    testWidgets('[CT04] Senha curta (sem atingir mínimo) → exibe erro', (tester) async {
      final caso = _CasoCadastro(
        id: 'CT04',
        descricao: 'Senha curta → Rejeitada',
        nome: 'Carlos Lima',
        email: 'carlos.lima@gmail.com',
        senha: 'abc12',
        confirmarSenha: 'abc12',
        mensagemErroEsperada: 'A senha deve ter no mínimo 6 caracteres.',
      );

      await _preencherEEnviarCadastro(tester, caso);

      expect(find.text(caso.mensagemErroEsperada!), findsOneWidget);
    });
  });

  group('US-16 · RegisterScreen — casos complementares', () {
    testWidgets('[EXTRA01] Senhas diferentes → exibe "As senhas não coincidem."', (tester) async {
      final caso = _CasoCadastro(
        id: 'EXTRA01',
        descricao: 'Confirmação de senha divergente',
        nome: 'Carlos Lima',
        email: 'carlos.lima@gmail.com',
        senha: 'Carlos123',
        confirmarSenha: 'Carlos456',
        mensagemErroEsperada: 'As senhas não coincidem.',
      );

      await _preencherEEnviarCadastro(tester, caso);

      expect(find.text(caso.mensagemErroEsperada!), findsOneWidget);
    });

    testWidgets('[EXTRA02] Termos não aceitos → exibe erro', (tester) async {
      final caso = _CasoCadastro(
        id: 'EXTRA02',
        descricao: 'Cadastro sem aceitar os termos',
        nome: 'Carlos Lima',
        email: 'carlos.lima@gmail.com',
        senha: 'Carlos123',
        confirmarSenha: 'Carlos123',
        aceitarTermos: false,
        mensagemErroEsperada: 'Aceite os termos para continuar.',
      );

      await _preencherEEnviarCadastro(tester, caso);

      expect(find.text(caso.mensagemErroEsperada!), findsOneWidget);
    });

    testWidgets('[EXTRA03] Nome vazio → exibe "Informe seu nome."', (tester) async {
      final caso = _CasoCadastro(
        id: 'EXTRA03',
        descricao: 'Cadastro sem informar o nome',
        nome: '',
        email: 'carlos.lima@gmail.com',
        senha: 'Carlos123',
        confirmarSenha: 'Carlos123',
        mensagemErroEsperada: 'Informe seu nome.',
      );

      await _preencherEEnviarCadastro(tester, caso);

      expect(find.text(caso.mensagemErroEsperada!), findsOneWidget);
    });
  });
}