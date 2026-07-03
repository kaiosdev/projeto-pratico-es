// test/us06_registro_emocional_screen_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/registro_emocional_screen.dart';

void main() {
  group('US-06 · RegistroEmocionalScreen — Testes de Integração', () {
    
    // Helper agora força um tamanho de tela gigante para que tudo caiba
    Future<void> _setupTeste(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 3000)); 
      await tester.pumpWidget(const MaterialApp(home: RegistroEmocionalScreen()));
      await tester.pumpAndSettle();
    }

    testWidgets('[CT01] Selecionar emoji válido e salvar → Sucesso', (tester) async {
      await _setupTeste(tester);

      await tester.tap(find.byKey(const Key('emoji_:)')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('btn_salvar')));
      await tester.pumpAndSettle();

      expect(find.text('Registro salvo com sucesso!'), findsOneWidget);
    });

    testWidgets('[CT02] Escala dentro de 1–10 → Registro realizado', (tester) async {
      await _setupTeste(tester);

      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pump();

      await tester.tap(find.byKey(const Key('btn_salvar')));
      await tester.pumpAndSettle();

      expect(find.text('Registro salvo com sucesso!'), findsOneWidget);
    });

    testWidgets('[CT03] Selecionar cor válida da paleta → Sucesso', (tester) async {
      await _setupTeste(tester);

      await tester.tap(find.byKey(const Key('cor_#FF0000')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('btn_salvar')));
      await tester.pumpAndSettle();

      expect(find.text('Registro salvo com sucesso!'), findsOneWidget);
    });

    testWidgets('[CT04] Nota com 501 caracteres → exibe erro', (tester) async {
      await _setupTeste(tester);

      final notaLonga = 'A' * 501;
      await tester.enterText(find.byKey(const Key('campo_nota')), notaLonga);
      await tester.pump();

      await tester.tap(find.byKey(const Key('btn_salvar')));
      await tester.pumpAndSettle();

      expect(find.text('A nota não pode ultrapassar 500 caracteres.'), findsOneWidget);
    });
  });
}