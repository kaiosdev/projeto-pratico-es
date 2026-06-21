class ValidadorAuth {
  
  static String? validarNome(String? nome) {
    if (nome == null || nome.trim().isEmpty) {
      return 'Informe seu nome.';
    }
    return null; // Retorna null quando é válido
  }

  static String? validarEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Informe seu e-mail.';
    }
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      return 'E-mail inválido.';
    }
    return null;
  }

  static String? validarSenha(String? senha) {
    // Defeito corrigido (Omissão, item 29 do relatório de inspeção):
    // a senha de cadastro local deve ter no mínimo 8 caracteres.
    if (senha == null || senha.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres.';
    }
    // O TP3 exige a validação de números na senha (CT04). Vamos adicionar a regra aqui:
    if (!RegExp(r'[0-9]').hasMatch(senha)) {
      return 'A senha deve conter pelo menos um número.';
    }
    return null;
  }

  /// Valida o código de verificação enviado por e-mail no cadastro (US-16).
  ///
  /// [codigoDigitado] é o que o usuário digitou na tela de Verificação de
  /// E-mail. [codigoEsperado] é o código gerado/enviado pelo backend.
  /// [expiraEm] é o instante em que esse código deixa de ser válido.
  ///
  /// Cenários do TP3 - Matriz de Rastreabilidade:
  ///   CT05  Código válido    → Aceito
  ///   CT06  Código expirado  → Rejeitado
  static String? validarCodigoVerificacao({
    required String? codigoDigitado,
    required String codigoEsperado,
    required DateTime expiraEm,
    DateTime? agora,
  }) {
    final momentoAtual = agora ?? DateTime.now();

    if (codigoDigitado == null || codigoDigitado.trim().isEmpty) {
      return 'Informe o código de verificação.';
    }

    if (momentoAtual.isAfter(expiraEm)) {
      return 'Código expirado. Solicite um novo código.';
    }

    if (codigoDigitado.trim() != codigoEsperado.trim()) {
      return 'Código de verificação inválido.';
    }

    return null;
  }
}
