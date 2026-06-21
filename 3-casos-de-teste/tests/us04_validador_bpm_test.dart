// test/us04_validador_bpm_test.dart
//
// Testes automatizados — US-04: Monitoramento Cardíaco
// Cenários alinhados ao Trabalho Prático III — Matriz de Rastreabilidade
//
// Cenários oficiais do PDF:
//   CT01  BPM=60   → Normal
//   CT02  BPM=80   → Normal
//   CT03  BPM=101  → Alerta
//   CT04  BPM=120  → Alerta
//
// Faixa saudável padrão alinhada ao defeito corrigido (Ambiguidade/Omissão,
// item 10 do relatório de inspeção): 60 a 100 BPM.
//
// Funções testadas (lib/src/utils/validador_bpm.dart):
//   • ValidadorBpm.validarBpm()  → também cobre gerarAlerta() via campo gerarAlerta
//
// Para executar:
//   flutter test test/us04_validador_bpm_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../lib/src/utils/validador_bpm.dart';

class _CasoBpm {
  final String id;
  final String descricao;
  final int bpm;
  final StatusBpm statusEsperado;
  final bool alertaEsperado;

  const _CasoBpm({
    required this.id,
    required this.descricao,
    required this.bpm,
    required this.statusEsperado,
    required this.alertaEsperado,
  });
}

void main() {
  // ══════════════════════════════════════════════════════════════════════════
  // CT01–CT04 — validarBpm() + gerarAlerta() (cenários oficiais do PDF)
  // ══════════════════════════════════════════════════════════════════════════
  group('US-04 · validarBpm() + gerarAlerta() — cenários oficiais do TP3', () {
    final casos = <_CasoBpm>[
      _CasoBpm(
        id: 'CT01',
        descricao: 'BPM=60 → Normal',
        bpm: 60,
        statusEsperado: StatusBpm.normal,
        alertaEsperado: false,
      ),
      _CasoBpm(
        id: 'CT02',
        descricao: 'BPM=80 → Normal',
        bpm: 80,
        statusEsperado: StatusBpm.normal,
        alertaEsperado: false,
      ),
      _CasoBpm(
        id: 'CT03',
        descricao: 'BPM=101 → Alerta',
        bpm: 101,
        statusEsperado: StatusBpm.elevado,
        alertaEsperado: true,
      ),
      _CasoBpm(
        id: 'CT04',
        descricao: 'BPM=120 → Alerta',
        bpm: 120,
        statusEsperado: StatusBpm.elevado,
        alertaEsperado: true,
      ),
    ];

    for (final caso in casos) {
      test('[${caso.id}] ${caso.descricao}', () {
        final resultado = ValidadorBpm.validarBpm(caso.bpm);

        expect(resultado.status, caso.statusEsperado,
            reason: '${caso.id}: BPM=${caso.bpm}');
        expect(resultado.gerarAlerta, caso.alertaEsperado,
            reason: '${caso.id}: BPM=${caso.bpm}');
      });
    }
  });

  // ══════════════════════════════════════════════════════════════════════════
  // Casos complementares (classes de equivalência adicionais — não exigidos
  // pelo PDF, mas reforçam fronteiras e a regra de intervalo de atualização)
  // ══════════════════════════════════════════════════════════════════════════
  group('US-04 · Casos complementares (fronteiras e bradicardia)', () {
    final casosBpm = <_CasoBpm>[
      _CasoBpm(
        id: 'EXTRA01',
        descricao: 'BPM=59 (1 abaixo do limite) deve gerar alerta de bradicardia',
        bpm: 59,
        statusEsperado: StatusBpm.abaixoDoNormal,
        alertaEsperado: true,
      ),
      _CasoBpm(
        id: 'EXTRA02',
        descricao: 'BPM=35 (bradicardia severa) deve gerar alerta',
        bpm: 35,
        statusEsperado: StatusBpm.abaixoDoNormal,
        alertaEsperado: true,
      ),
      _CasoBpm(
        id: 'EXTRA03',
        descricao: 'BPM=60 (limite inferior exato) não deve gerar alerta',
        bpm: 60,
        statusEsperado: StatusBpm.normal,
        alertaEsperado: false,
      ),
      _CasoBpm(
        id: 'EXTRA04',
        descricao: 'BPM=100 (limite superior exato) não deve gerar alerta',
        bpm: 100,
        statusEsperado: StatusBpm.normal,
        alertaEsperado: false,
      ),
    ];

    for (final caso in casosBpm) {
      test('[${caso.id}] ${caso.descricao}', () {
        final resultado = ValidadorBpm.validarBpm(caso.bpm);
        expect(resultado.status, caso.statusEsperado);
        expect(resultado.gerarAlerta, caso.alertaEsperado);
      });
    }

    test('[EXTRA05] Intervalo de atualização válido (10s) deve ser aceito',
        () {
      expect(ValidadorBpm.validarIntervalo(10), isNull);
    });

    test('[EXTRA06] Intervalo muito curto (2s) deve ser rejeitado', () {
      expect(ValidadorBpm.validarIntervalo(2), isNotNull);
    });

    test('[EXTRA07] Intervalo muito longo (90s) deve ser rejeitado', () {
      expect(ValidadorBpm.validarIntervalo(90), isNotNull);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // gerarAlerta() isolada — o PDF nomeia esta função separadamente de
  // validarBpm(), então ela também é testada diretamente aqui, fora do
  // contexto do ResultadoBpm.
  // ══════════════════════════════════════════════════════════════════════════
  group('US-04 · gerarAlerta() — testada isoladamente', () {
    test('[EXTRA08] status normal não deve gerar alerta', () {
      expect(ValidadorBpm.gerarAlerta(StatusBpm.normal), isFalse);
    });

    test('[EXTRA09] status elevado deve gerar alerta', () {
      expect(ValidadorBpm.gerarAlerta(StatusBpm.elevado), isTrue);
    });

    test('[EXTRA10] status abaixo do normal deve gerar alerta', () {
      expect(ValidadorBpm.gerarAlerta(StatusBpm.abaixoDoNormal), isTrue);
    });
  });
}
