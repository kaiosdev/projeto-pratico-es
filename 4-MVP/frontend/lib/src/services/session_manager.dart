// lib/src/services/session_manager.dart
//
// Guarda e recupera o token JWT no dispositivo, usando shared_preferences.
// Isso permite que o usuário continue logado mesmo se fechar e abrir o app.

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _chaveToken = 'auth_token';
  static const String _chaveUsuarioId = 'usuario_id';
  static const String _chaveUsuarioNome = 'usuario_nome';

  // Salva o token e os dados básicos do usuário após login/cadastro
  static Future<void> salvarSessao({
    required String token,
    required int usuarioId,
    required String usuarioNome,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveToken, token);
    await prefs.setInt(_chaveUsuarioId, usuarioId);
    await prefs.setString(_chaveUsuarioNome, usuarioNome);
  }

  // Recupera o token salvo (null se não houver usuário logado)
  static Future<String?> obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chaveToken);
  }

  static Future<String?> obterNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chaveUsuarioNome);
  }

  // Remove todos os dados de sessão (usado no logout)
  static Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveToken);
    await prefs.remove(_chaveUsuarioId);
    await prefs.remove(_chaveUsuarioNome);
  }
}
