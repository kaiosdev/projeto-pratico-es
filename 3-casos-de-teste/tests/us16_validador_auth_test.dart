// test/us16_validador_auth_test.dart
//
// Testes automatizados — US-16: Cadastro e Login
// Cenários alinhados ao Trabalho Prático III — Matriz de Rastreabilidade
//
// Cenários oficiais do PDF:
//   CT01  Email válido               → Aceito
//   CT02  Email inválido             → Rejeitado
//   CT03  Senha válida               → Aceita
//   CT04  Senha sem número           → Rejeitada
//   CT05  Código válido              → Aceito   (validarCodigoVerificacao)
//   CT06  Código expirado            → Rejeitado (validarCodigoVerificacao)
//
// Senha alinhada ao defeito corrigido (Omissão, item 29 do relatório de
// inspeção): mínimo de 8 caracteres e ao menos 1 número.
//
// CT05 e CT06 testam validarCodigoVerificacao(), que depende de tempo
// (expiração). Para tornar o teste determinístico (sem depender do relógio
// real da máquina), a função aceita um parâmetro opcional `agora` — o teste
// "congela" esse instante em vez de usar DateTime.now().
//
// Funções testadas (lib/src/utils/validador_auth.dart):
//   • ValidadorAuth.validarEmail()
//   • ValidadorAuth.validarSenha()
//   • ValidadorAuth.validarCodigoVerificacao()
//
// Para executar:
//   flutter test test/us16_validador_auth_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../lib/src/utils/validador_auth.dart';

class _Caso<T> {
  final String id;
  final String descricao;
  final T entrada;
  final String? erroEsperado;

  const _Caso({
    required this.id,
    required this.descricao,
    required this.entrada,
    required this.erroEsperado,
  });
}

void main() {
  // ══════════════════════════════════════════════════════════════════════════
  // CT01 e CT02 — validarEmail() (cenários oficiais do PDF)
  // ══════════════════════════════════════════════════════════════════════════
  group('US-16 · validarEmail() — cenários oficiais do TP3', () {
    final casos = <_Caso<String>>[
      _Caso(
        id: 'CT01',
        descricao: 'Email válido → Aceito',
        entrada: 'user@gmail.com',
        erroEsperado: null,
      ),
      _Caso(
        id: 'CT02',
        descricao: 'Email inválido → Rejeitado',
        entrada: 'usergmail.com',
        erroEsperado: 'E-mail inválido.',
      ),
    ];

    for (final caso in casos) {
      test('[${caso.id}] ${caso.descricao}', () {
        final resultado = ValidadorAuth.validarEmail(caso.entrada);
        expect(resultado, caso.erroEsperado,
            reason: '${caso.id}: entrada="${caso.entrada}"');
      });
    }
  });

  // ══════════════════════════════════════════════════════════════════════════
  // CT03 e CT04 — validarSenha() (cenários oficiais do PDF)
  // ══════════════════════════════════════════════════════════════════════════
  group('US-16 · validarSenha() — cenários oficiais do TP3', () {
    final casos = <_Caso<String>>[
      _Caso(
        id: 'CT03',
        descricao: 'Senha válida (8+ chars, com número) → Aceita',
        entrada: 'Carlos123',
        erroEsperado: null,
      ),
      _Caso(
        id: 'CT04',
        descricao: 'Senha sem número → Rejeitada',
        entrada: 'SenhaSegura',
        erroEsperado: 'A senha deve conter pelo menos um número.',
      ),
    ];

    for (final caso in casos) {
      test('[${caso.id}] ${caso.descricao}', () {
        final resultado = ValidadorAuth.validarSenha(caso.entrada);
        expect(resultado, caso.erroEsperado,
            reason: '${caso.id}: entrada="${caso.entrada}"');
      });
    }
  });

  // ══════════════════════════════════════════════════════════════════════════
  // Casos complementares (classes de equivalência adicionais — não exigidos
  // pelo PDF, mas reforçam a cobertura de fronteira)
  // ══════════════════════════════════════════════════════════════════════════
  group('US-16 · Casos complementares (classes de equivalência extra)', () {
    final casosEmail = <_Caso<String>>[
      _Caso(
        id: 'EXTRA01',
        descricao: 'Email sem domínio deve ser rejeitado',
        entrada: 'user@',
        erroEsperado: 'E-mail inválido.',
      ),
      _Caso(
        id: 'EXTRA02',
        descricao: 'Email vazio deve exigir preenchimento',
        entrada: '',
        erroEsperado: 'Informe seu e-mail.',
      ),
    ];
    for (final caso in casosEmail) {
      test('[${caso.id}] ${caso.descricao}', () {
        final resultado = ValidadorAuth.validarEmail(caso.entrada);
        expect(resultado, caso.erroEsperado);
      });
    }

    final casosSenha = <_Caso<String>>[
      _Caso(
        id: 'EXTRA03',
        descricao: 'Senha com 6 caracteres (abaixo do mínimo de 8) deve ser rejeitada',
        entrada: 'Abc123',
        erroEsperado: 'A senha deve ter no mínimo 8 caracteres.',
      ),
      _Caso(
        id: 'EXTRA04',
        descricao: 'Senha vazia deve ser rejeitada',
        entrada: '',
        erroEsperado: 'A senha deve ter no mínimo 8 caracteres.',
      ),
      _Caso(
        id: 'EXTRA05',
        descricao: 'Senha com 8 caracteres mas sem número deve ser rejeitada',
        entrada: 'Abcdefgh',
        erroEsperado: 'A senha deve conter pelo menos um número.',
      ),
      _Caso(
        id: 'EXTRA06',
        descricao: 'Senha com exatamente 8 caracteres e número deve ser aceita',
        entrada: 'Abcdefg1',
        erroEsperado: null,
      ),
    ];
    for (final caso in casosSenha) {
      test('[${caso.id}] ${caso.descricao}', () {
        final resultado = ValidadorAuth.validarSenha(caso.entrada);
        expect(resultado, caso.erroEsperado);
      });
    }
  });

  // ══════════════════════════════════════════════════════════════════════════
  // CT05 e CT06 — validarCodigoVerificacao() (cenários oficiais do PDF)
  // ══════════════════════════════════════════════════════════════════════════
  group('US-16 · validarCodigoVerificacao() — cenários oficiais do TP3', () {
    // Instante fixo usado como "agora" em todos os testes deste grupo,
    // para que o resultado nunca dependa do relógio real da máquina.
    final agora = DateTime(2026, 6, 20, 12, 0, 0);
    final expiraNoFuturo = agora.add(const Duration(minutes: 5));
    final expirouNoPassado = agora.subtract(const Duration(minutes: 5));

    test('[CT05] Código válido → Aceito', () {
      final resultado = ValidadorAuth.validarCodigoVerificacao(
        codigoDigitado: '123456',
        codigoEsperado: '123456',
        expiraEm: expiraNoFuturo,
        agora: agora,
      );
      expect(resultado, isNull);
    });

    test('[CT06] Código expirado → Rejeitado', () {
      final resultado = ValidadorAuth.validarCodigoVerificacao(
        codigoDigitado: '123456',
        codigoEsperado: '123456',
        expiraEm: expirouNoPassado,
        agora: agora,
      );
      expect(resultado, 'Código expirado. Solicite um novo código.');
    });

    test('[EXTRA07] Código digitado diferente do esperado → Rejeitado', () {
      final resultado = ValidadorAuth.validarCodigoVerificacao(
        codigoDigitado: '000000',
        codigoEsperado: '123456',
        expiraEm: expiraNoFuturo,
        agora: agora,
      );
      expect(resultado, 'Código de verificação inválido.');
    });

    test('[EXTRA08] Código vazio → exige preenchimento', () {
      final resultado = ValidadorAuth.validarCodigoVerificacao(
        codigoDigitado: '',
        codigoEsperado: '123456',
        expiraEm: expiraNoFuturo,
        agora: agora,
      );
      expect(resultado, 'Informe o código de verificação.');
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // Cenário completo — caminho feliz com todas as entradas válidas
  // ══════════════════════════════════════════════════════════════════════════
  group('US-16 · Cenário completo (caminho feliz)', () {
    test('Email válido + senha válida → ambas as funções retornam null', () {
      const email = 'user@gmail.com';
      const senha = 'Carlos123';

      expect(ValidadorAuth.validarEmail(email), isNull);
      expect(ValidadorAuth.validarSenha(senha), isNull);
    });
  });
}
