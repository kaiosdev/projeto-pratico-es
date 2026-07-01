// test/us06_validador_registro_emocional_test.dart
//
// Testes automatizados — US-06: Registro Emocional Diário
// Cenários alinhados ao Trabalho Prático III — Matriz de Rastreabilidade
//
// Cenários oficiais do PDF:
//   CT01  Emoji válido           → Registro realizado
//   CT02  Escala 1–10            → Registro realizado
//   CT03  Cor válida             → Registro realizado
//   CT04  Nota com 501 caracteres → Erro
//
// Funções testadas (lib/src/utils/validador_registro_emocional.dart):
//   • ValidadorRegistroEmocional.validarEmoji()
//   • ValidadorRegistroEmocional.validarEscala()
//   • ValidadorRegistroEmocional.validarCor()
//   • ValidadorRegistroEmocional.validarNota()
//
// Para executar:
//   flutter test test/us06_validador_registro_emocional_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../lib/src/utils/validador_registro_emocional.dart';

void main() {
  // ══════════════════════════════════════════════════════════════════════════
  // CT01–CT04 — cenários oficiais do PDF
  // ══════════════════════════════════════════════════════════════════════════
  group('US-06 · Cenários oficiais do TP3', () {
    test('[CT01] Emoji válido → Registro realizado', () {
      final resultado = ValidadorRegistroEmocional.validarEmoji(':)');
      expect(resultado, isNull);
    });

    test('[CT02] Escala 1–10 → Registro realizado', () {
      final resultado = ValidadorRegistroEmocional.validarEscala(7);
      expect(resultado, isNull);
    });

    test('[CT03] Cor válida → Registro realizado', () {
      final resultado = ValidadorRegistroEmocional.validarCor('#FF0000');
      expect(resultado, isNull);
    });

    test('[CT04] Nota com 501 caracteres → Erro', () {
      final notaLonga = 'A' * 501;
      final resultado = ValidadorRegistroEmocional.validarNota(notaLonga);
      expect(resultado, isNotNull);
      expect(resultado,
          'A nota não pode ultrapassar ${ValidadorRegistroEmocional.notaMaxChars} caracteres.');
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // Casos complementares (classes de equivalência adicionais — não exigidos
  // pelo PDF, mas reforçam a cobertura de inválidos e fronteiras)
  // ══════════════════════════════════════════════════════════════════════════
  group('US-06 · Casos complementares (inválidos e fronteiras)', () {
    test('[EXTRA01] Emoji inválido deve ser rejeitado', () {
      expect(ValidadorRegistroEmocional.validarEmoji(r'$%'), isNotNull);
    });

    test('[EXTRA02] Campo de emoji vazio deve exigir seleção', () {
      expect(ValidadorRegistroEmocional.validarEmoji(''), isNotNull);
    });

    test('[EXTRA03] Escala=0 (abaixo do mínimo) deve ser rejeitada', () {
      expect(ValidadorRegistroEmocional.validarEscala(0), isNotNull);
    });

    test('[EXTRA04] Escala=11 (acima do máximo) deve ser rejeitada', () {
      expect(ValidadorRegistroEmocional.validarEscala(11), isNotNull);
    });

    test('[EXTRA05] Cor fora da paleta deve ser rejeitada', () {
      expect(ValidadorRegistroEmocional.validarCor('#123456'), isNotNull);
    });

    test('[EXTRA06] Cor vazia deve exigir seleção', () {
      expect(ValidadorRegistroEmocional.validarCor(''), isNotNull);
    });

    test('[EXTRA07] Nota com exatamente 500 caracteres deve ser aceita', () {
      final nota = 'B' * 500;
      expect(ValidadorRegistroEmocional.validarNota(nota), isNull);
    });

    test('[EXTRA08] Nota vazia (campo opcional) deve ser aceita', () {
      expect(ValidadorRegistroEmocional.validarNota(''), isNull);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // registrarHumor() — o PDF nomeia esta função como candidata à automação
  // da US-06, combinando emoji + escala + cor num único registro.
  // ══════════════════════════════════════════════════════════════════════════
  group('US-06 · registrarHumor() — combinação de emoji, escala e cor', () {
    test('[EXTRA09] Todos os campos válidos → registro válido', () {
      final resultado = ValidadorRegistroEmocional.registrarHumor(
        emoji: ':)',
        escala: 7,
        cor: '#FF0000',
      );
      expect(resultado.valido, isTrue);
      expect(resultado.primeiroErro, isNull);
    });

    test('[EXTRA10] Emoji inválido → registro inválido, erro reportado', () {
      final resultado = ValidadorRegistroEmocional.registrarHumor(
        emoji: r'$%',
        escala: 7,
        cor: '#FF0000',
      );
      expect(resultado.valido, isFalse);
      expect(resultado.erroEmoji, isNotNull);
      expect(resultado.erroEscala, isNull);
      expect(resultado.erroCor, isNull);
    });

    test('[EXTRA11] Escala fora do intervalo → registro inválido', () {
      final resultado = ValidadorRegistroEmocional.registrarHumor(
        emoji: ':)',
        escala: 15,
        cor: '#FF0000',
      );
      expect(resultado.valido, isFalse);
      expect(resultado.erroEscala, isNotNull);
    });

    test('[EXTRA12] Cor fora da paleta → registro inválido', () {
      final resultado = ValidadorRegistroEmocional.registrarHumor(
        emoji: ':)',
        escala: 7,
        cor: '#123456',
      );
      expect(resultado.valido, isFalse);
      expect(resultado.erroCor, isNotNull);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // Cenário completo — caminho feliz com todas as entradas válidas
  // ══════════════════════════════════════════════════════════════════════════
  group('US-06 · Cenário completo (caminho feliz)', () {
    test(
        'Emoji válido + escala 7 + cor válida + nota curta → todas as funções retornam null',
        () {
      expect(ValidadorRegistroEmocional.validarEmoji(':)'), isNull);
      expect(ValidadorRegistroEmocional.validarEscala(7), isNull);
      expect(ValidadorRegistroEmocional.validarCor('#FFD700'), isNull);
      expect(ValidadorRegistroEmocional.validarNota('Me senti bem hoje.'),
          isNull);
    });
  });
}