class ValidadorAuth {
  
  static String? validarNome(String? nome) {
    if (nome == null || nome.trim().isEmpty) {
      return 'Informe seu nome.';
    }
    return null;
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
    // Regra de negócio (US-16 — Classes de Equivalência): mínimo de 6 caracteres.
    if (senha == null || senha.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }
    // Regra de Negócio: Pelo menos 1 número (CT04 da matriz)
    if (!RegExp(r'[0-9]').hasMatch(senha)) {
      return 'A senha deve conter pelo menos um número.';
    }
    return null;
  }

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