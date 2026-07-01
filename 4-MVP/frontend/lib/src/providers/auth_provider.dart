import 'dart:async'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/usuario_model.dart';
import '../repositories/auth_repository.dart';
import '../services/session_manager.dart';
import '../services/api_client.dart'; 

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

class AuthNotifier extends AsyncNotifier<UsuarioModel?> {
  @override
  FutureOr<UsuarioModel?> build() async {
    return null;
  }

  // Fluxo de Cadastro Relacional
  Future<void> registar(String nome, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(nome);
      final token = await userCredential.user!.getIdToken();
      
      await SessionManager.salvarSessao(
        token: token!,
        usuarioId: 0, 
        usuarioNome: nome,
      );

      final repo = ref.read(authRepositoryProvider);
      final usuarioMysql = await repo.syncUsuario(nome);

      await SessionManager.salvarSessao(
        token: token,
        usuarioId: usuarioMysql.id,
        usuarioNome: usuarioMysql.nome,
      );

      return usuarioMysql;
    });
    
    if (state.hasError) {
      print("🚨 ERRO NO CADASTRO: ${state.error}");
      throw Exception(_tratarErroFirebase(state.error.toString()));
    }
  }

  // Fluxo de Autenticação / Login
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Autentica no Firebase
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Obtém o token JWT atualizado
      final token = await userCredential.user!.getIdToken();
      
      // 3. Salva sessão inicial para o interceptor do Dio capturar
      await SessionManager.salvarSessao(
        token: token!,
        usuarioId: 0,
        usuarioNome: userCredential.user!.displayName ?? '',
      );

      // 4. Sincroniza e busca o perfil persistido no MySQL
      final repo = ref.read(authRepositoryProvider);
      final usuarioMysql = await repo.syncUsuario(userCredential.user!.displayName ?? '');

      // 5. Atualiza a sessão local com os IDs definitivos do banco
      await SessionManager.salvarSessao(
        token: token,
        usuarioId: usuarioMysql.id,
        usuarioNome: usuarioMysql.nome,
      );

      return usuarioMysql;
    });

    if (state.hasError) {
      print("🚨 ERRO NO LOGIN: ${state.error}");
      throw Exception(_tratarErroFirebase(state.error.toString()));
    }
  }

  String _tratarErroFirebase(String erro) {
    if (erro.contains('email-already-in-use')) return 'Este e-mail já está em uso.';
    if (erro.contains('invalid-email')) return 'O e-mail fornecido é inválido.';
    if (erro.contains('weak-password')) return 'A senha é muito fraca.';
    if (erro.contains('user-not-found') || erro.contains('wrong-password') || erro.contains('invalid-credential')) {
      return 'E-mail ou senha incorretos.';
    }
    return erro.replaceAll('Exception: ', '');
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UsuarioModel?>(AuthNotifier.new);