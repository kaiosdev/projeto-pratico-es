// lib/src/utils/validador_registro_emocional.dart
//
// Validador para a US-06 — Registro Emocional Diário.
// Regras (conforme TP3 - Matriz de Rastreabilidade):
//   • Emoji deve pertencer ao conjunto válido
//   • Escala emocional deve ser entre 1 e 10
//   • Cor deve pertencer à paleta de cores associada ao humor
//   • Nota textual opcional não pode ultrapassar 500 caracteres

class ResultadoRegistroHumor {
  final bool valido;
  final String? erroEmoji;
  final String? erroEscala;
  final String? erroCor;

  const ResultadoRegistroHumor._({
    required this.valido,
    this.erroEmoji,
    this.erroEscala,
    this.erroCor,
  });

  /// Retorna o primeiro erro encontrado (na ordem emoji → escala → cor),
  /// útil para exibir uma única mensagem por vez na interface.
  String? get primeiroErro => erroEmoji ?? erroEscala ?? erroCor;
}

class ValidadorRegistroEmocional {
  // Conjunto de emojis aceitos pelo app
  static const Set<String> emojisValidos = {
    ':)', ':D', ':(', ':/', ':o', ':P', '<3', ';)', ':*',
  };

  // Paleta de cores associada ao humor (ex.: vermelho = raiva, azul = tristeza)
  static const Map<String, String> coresValidas = {
    '#FF0000': 'Raiva',
    '#0000FF': 'Tristeza',
    '#FFD700': 'Alegria',
    '#808080': 'Neutro/Cansaço',
    '#800080': 'Ansiedade',
    '#008000': 'Calma',
  };

  static const int escalaMin = 1;
  static const int escalaMax = 10;
  static const int notaMaxChars = 500;

  /// Verifica apenas o FORMATO do emoji (pertence ao conjunto válido),
  /// sem exigir que esteja preenchido. Usado internamente por
  /// registrarHumor(), onde o campo é opcional.
  static bool _formatoEmojiValido(String emoji) =>
      emojisValidos.contains(emoji.trim());

  /// Valida o emoji de humor como campo OBRIGATÓRIO e isolado
  /// (ex.: validação em tempo real de um único campo do formulário).
  static String? validarEmoji(String? emoji) {
    if (emoji == null || emoji.trim().isEmpty) {
      return 'Selecione um emoji para registrar seu humor.';
    }
    if (!_formatoEmojiValido(emoji)) {
      return 'Emoji de humor inválido.';
    }
    return null;
  }

  /// Valida a escala emocional (1–10).
  static String? validarEscala(int? valor) {
    if (valor == null) return 'Informe um valor na escala emocional.';
    if (valor < escalaMin || valor > escalaMax) {
      return 'A escala emocional deve ser entre $escalaMin e $escalaMax.';
    }
    return null;
  }

  /// Verifica apenas o FORMATO da cor (pertence à paleta válida),
  /// sem exigir que esteja preenchida. Usado internamente por
  /// registrarHumor(), onde o campo é opcional.
  static bool _formatoCorValido(String corHex) =>
      coresValidas.containsKey(corHex.trim().toUpperCase());

  /// Valida a cor associada ao humor como campo OBRIGATÓRIO e isolado
  /// (deve pertencer à paleta pré-definida).
  static String? validarCor(String? corHex) {
    if (corHex == null || corHex.trim().isEmpty) {
      return 'Selecione uma cor para representar seu humor.';
    }
    if (!_formatoCorValido(corHex)) {
      return 'Cor inválida. Selecione uma cor da paleta disponível.';
    }
    return null;
  }

  /// Valida a nota textual opcional (máx. 500 caracteres).
  static String? validarNota(String? nota) {
    if (nota == null || nota.isEmpty) return null; // campo opcional
    if (nota.length > notaMaxChars) {
      return 'A nota não pode ultrapassar $notaMaxChars caracteres.';
    }
    return null;
  }

  /// Registra o humor do dia. A escala emocional é o único campo obrigatório
  /// (sempre possui um valor padrão na interface) e deve estar entre 1 e 10.
  /// Emoji e cor são opcionais: se o usuário selecionar algum, ele precisa
  /// pertencer ao conjunto/paleta válidos, mas a ausência deles não impede
  /// o registro (CT01–CT03 do TP3 - Matriz de Rastreabilidade da US-06).
  /// A obrigatoriedade isolada de validarEmoji()/validarCor() é usada em
  /// outros contextos (ex.: EXTRA02/EXTRA06), não aqui.
  /// A nota textual é validada separadamente por validarNota().
  static ResultadoRegistroHumor registrarHumor({
    required String? emoji,
    required int? escala,
    required String? cor,
  }) {
    final erroEscala = validarEscala(escala);

    String? erroEmoji;
    if (emoji != null && emoji.trim().isNotEmpty && !_formatoEmojiValido(emoji)) {
      erroEmoji = 'Emoji de humor inválido.';
    }

    String? erroCor;
    if (cor != null && cor.trim().isNotEmpty && !_formatoCorValido(cor)) {
      erroCor = 'Cor inválida. Selecione uma cor da paleta disponível.';
    }

    return ResultadoRegistroHumor._(
      valido: erroEmoji == null && erroEscala == null && erroCor == null,
      erroEmoji: erroEmoji,
      erroEscala: erroEscala,
      erroCor: erroCor,
    );
  }
}