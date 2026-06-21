// lib/src/utils/validador_bpm.dart
//
// Validador para a US-04 — Monitoramento Cardíaco.

enum StatusBpm { abaixoDoNormal, normal, elevado }

class ResultadoBpm {
  final bool valido;
  final StatusBpm? status;
  final bool gerarAlerta;
  final String? mensagemErro;

  const ResultadoBpm._({
    required this.valido,
    this.status,
    required this.gerarAlerta,
    this.mensagemErro,
  });

  factory ResultadoBpm.aceito(StatusBpm status) => ResultadoBpm._(
        valido: true,
        status: status,
        gerarAlerta: ValidadorBpm.gerarAlerta(status),
      );

  factory ResultadoBpm.rejeitado(String mensagem) => ResultadoBpm._(
        valido: false,
        gerarAlerta: false,
        mensagemErro: mensagem,
      );
}

class ValidadorBpm {
  // Faixa saudável padrão (defeito corrigido — Ambiguidade/Omissão,
  // item 10 do relatório de inspeção): 60 a 100 BPM. O app permite que o
  // usuário personalize esses limites nas configurações, mas este é o
  // valor padrão usado pelo validador.
  static const int bpmMin = 60;
  static const int bpmMax = 100;
  static const int intervaloMinSeg = 5;
  static const int intervaloMaxSeg = 60;

  static ResultadoBpm validarBpm(int bpm) {
    if (bpm < bpmMin) return ResultadoBpm.aceito(StatusBpm.abaixoDoNormal);
    if (bpm > bpmMax) return ResultadoBpm.aceito(StatusBpm.elevado);
    return ResultadoBpm.aceito(StatusBpm.normal);
  }

  /// Determina se uma leitura deve gerar alerta, a partir do status já
  /// classificado por validarBpm(). Nomeada separadamente (gerarAlerta())
  /// porque o TP3 - Matriz de Rastreabilidade a lista como uma das duas
  /// funções candidatas à automação da US-04, junto de validarBPM().
  static bool gerarAlerta(StatusBpm status) {
    return status != StatusBpm.normal;
  }

  static String? validarIntervalo(int intervaloSeg) {
    if (intervaloSeg < intervaloMinSeg) {
      return 'O intervalo mínimo de atualização é de ${intervaloMinSeg}s.';
    }
    if (intervaloSeg > intervaloMaxSeg) {
      return 'O intervalo máximo de atualização é de ${intervaloMaxSeg}s.';
    }
    return null;
  }
}
