import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'session_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthResult {
  final bool sucesso;
  final String? mensagemErro;
  final String? uid;

  const AuthResult({required this.sucesso, this.mensagemErro, this.uid});

  factory AuthResult.sucessoCom({String? uid}) => AuthResult(sucesso: true, uid: uid);
  factory AuthResult.erro(String mensagem) => AuthResult(sucesso: false, mensagemErro: mensagem);
}

class AuthService {
  /// Verifica o código de confirmação enviado durante o cadastro (US-16).
  static Future<bool> verificarCodigo({required String email, required String codigo}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'codigo': codigo}),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao verificar OTP: $e');
      return false;
    }
  }

  /// Login/cadastro via Google: autentica no Firebase e sincroniza o
  /// usuário com o backend (POST /auth/sync).
  static Future<AuthResult> loginComGoogle() async {
    try {
      // 1. Inicia o fluxo de login nativo do Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        return AuthResult.erro('Login com Google cancelado.'); 
      }

      // 2. Obtém os detalhes de autenticação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Cria a credencial para o Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Autentica no Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        return AuthResult.erro('Erro interno ao processar dados do Google.');
      }

      // 5. Pega o Token JWT do Firebase
      final String? tokenFirebase = await user.getIdToken();

      // 6. Sincroniza os dados do usuário com o backend Node.js
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenFirebase'
        },
        body: jsonEncode({
          'nome': user.displayName ?? 'Usuário do Google',
        }),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        await SessionManager.salvarSessao(
          token: tokenFirebase ?? '', 
          usuarioId: body['usuario']['id'] ?? 0,
          usuarioNome: body['usuario']['nome'] ?? user.displayName ?? 'Usuário',
        );
        return AuthResult.sucessoCom(uid: user.uid);
      }

      return AuthResult.erro(body['mensagem'] ?? 'Erro ao sincronizar com servidor.');

    } catch (e) {
      debugPrint('Erro no login com Google: $e');
      return AuthResult.erro('Não foi possível conectar ao Google. Verifique sua conexão.');
    }
  }
}