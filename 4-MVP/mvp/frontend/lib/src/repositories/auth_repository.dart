import 'package:dio/dio.dart';
import '../models/usuario_model.dart';

class AuthRepository {
  final Dio _client;

  AuthRepository(this._client);

  Future<UsuarioModel> syncUsuario(String nomeOpcional) async {
    try {
      final response = await _client.post('/auth/sync', data: {
        'nome': nomeOpcional,
      });
      return UsuarioModel.fromJson(response.data['usuario']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['mensagem'] ?? 'Falha ao sincronizar dados com o servidor.');
    }
  }
}