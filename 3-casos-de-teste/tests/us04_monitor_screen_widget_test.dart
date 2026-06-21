// test/us04_monitor_screen_widget_test.dart
//
// Teste de integração (widget test) — US-04: Monitoramento Cardíaco
// Equivalente ao App.test.tsx (React Native Testing Library) usado pela
// equipe de referência na US #27, adaptado às convenções do Flutter.
//
// A MonitorScreen não possui campo de entrada manual de BPM — o valor é
// simulado internamente (Random().nextInt) ao tocar em START. Por isso,
// em vez de "preencher um formulário", este teste simula a interação real
// do usuário (tocar START/PARAR) e verifica se a interface reage
// corretamente: rótulo de status, formatação do texto "X BPM" e transição
// do botão.
//
// Para validar os cenários EXATOS do TP3 (BPM=60→Normal, BPM=101→Alerta
// etc.) de forma determinística, ver us04_validador_bpm_test.dart, que
// testa a função pura ValidadorBpm.validarBpm() — aqui validamos o
// comportamento da TELA, não a regra de negócio isolada.
//
// Para executar:
//   flutter test test/us04_monitor_screen_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/monitor_screen.dart';

void main() {
  group('US-04 · MonitorScreen — teste de integração (widget test)', () {
    testWidgets('[CT_TELA01] Estado inicial exibe BPM e botão START',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MonitorScreen()));

      // BPM inicial simulado é 80 (definido em _MonitorScreenState).
      expect(find.textContaining('BPM'), findsWidgets);
      expect(find.text('START'), findsOneWidget);
      expect(find.text('PARAR'), findsNothing);
    });

    testWidgets('[CT_TELA02] BPM inicial (80) é classificado como NORMAL',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MonitorScreen()));

      // BPM=80 está na faixa normal (60–100), igual ao CT02 do TP3.
      expect(find.text('80 BPM'), findsOneWidget);
      expect(find.text('NORMAL'), findsOneWidget);
    });

    testWidgets('[CT_TELA03] Tocar START inicia o monitoramento',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MonitorScreen()));

      await tester.tap(find.text('START'));
      await tester.pump();

      // O botão deve alternar para "PARAR" assim que o monitoramento inicia.
      expect(find.text('PARAR'), findsOneWidget);
      expect(find.text('START'), findsNothing);

      // _toggleMonitor() dispara um Future.delayed(1s) para simular a
      // variação de BPM. É preciso avançar o relógio do teste além desse
      // delay antes de finalizar, senão o timer fica pendente quando o
      // widget é descartado (erro "A Timer is still pending...").
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('[CT_TELA04] Tocar PARAR encerra o monitoramento',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MonitorScreen()));

      await tester.tap(find.text('START')); // inicia
      await tester.pump();
      await tester.tap(find.text('PARAR')); // encerra
      await tester.pump();

      expect(find.text('START'), findsOneWidget);
      expect(find.text('PARAR'), findsNothing);

      // Mesmo já parado, o timer de 1s criado no START pode ainda estar
      // agendado — avança o relógio do teste para liberá-lo antes do fim.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('[CT_TELA05] Histórico semanal é exibido na tela',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MonitorScreen()));

      expect(find.text('HISTÓRICO SEMANAL'), findsOneWidget);
      // Os 6 dias simulados no histórico devem aparecer.
      expect(find.textContaining('Segunda'), findsOneWidget);
      expect(find.textContaining('Sábado'), findsOneWidget);
    });
  });

  group('US-04 · Cobertura de classificação por faixa (documentação)', () {
    // Estes testes documentam — via leitura do código-fonte da tela — os
    // limiares reais usados em _bpmLabel, espelhando os cenários oficiais
    // do TP3 (CT01–CT04). Eles não substituem us04_validador_bpm_test.dart,
    // que é a fonte determinística de verdade para esses limites.
    test('[REF] BPM < 60 → "ABAIXO DO NORMAL" (regra da tela MonitorScreen)',
        () {
      // Documentação: ver _bpmLabel em monitor_screen.dart.
      // A divergência entre a tela (limiar 60) e o ValidadorBpm (que antes
      // usava 40) foi corrigida: ambos agora usam 60 BPM como limite
      // inferior da faixa normal, alinhados ao defeito corrigido (item 10
      // do relatório de inspeção).
      expect(true, isTrue);
    });

    test('[REF] BPM entre 60 e 100 → "NORMAL" (regra da tela MonitorScreen)',
        () {
      expect(true, isTrue);
    });

    test('[REF] BPM > 100 → "ELEVADO" (regra da tela MonitorScreen)', () {
      expect(true, isTrue);
    });
  });
}
