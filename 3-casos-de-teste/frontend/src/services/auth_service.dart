import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'session_manager.dart';

class AuthResult {
  final bool sucesso;
  final String? mensagemErro;
  final String? uid;

  const AuthResult({required this.sucesso, this.mensagemErro, this.uid});

  factory AuthResult.sucessoCom({String? uid}) => AuthResult(sucesso: true, uid: uid);
  factory AuthResult.erro(String mensagem) => AuthResult(sucesso: false, mensagemErro: mensagem);
}

class AuthService {
  /// Realiza login e já salva a sessão localmente em caso de sucesso.
  static Future<AuthResult> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        // Salvando o JWT e os dados do usuário no dispositivo
        await SessionManager.salvarSessao(
          token: body['token'] ?? '', // Assumindo que sua API retorna um 'token'
          usuarioId: body['id'] ?? 0,
          usuarioNome: body['nome'] ?? 'Usuário',
        );
        return AuthResult.sucessoCom(uid: body['uid']?.toString());
      }

      return AuthResult.erro(body['mensagem'] ?? 'E-mail ou senha incorretos.');
    } catch (_) {
      return AuthResult.erro('Não foi possível conectar ao servidor. Verifique sua conexão.');
    }
  }

  /// Cria uma nova conta de usuário.
  static Future<AuthResult> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResult.sucessoCom(uid: body['uid']?.toString());
      }

      return AuthResult.erro(body['mensagem'] ?? 'Não foi possível criar a conta.');
    } catch (_) {
      return AuthResult.erro('Não foi possível conectar ao servidor. Verifique sua conexão.');
    }
  }
}