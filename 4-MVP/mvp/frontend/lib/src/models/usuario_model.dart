class UsuarioModel {
  final int id;
  final String firebaseUid;
  final String nome;
  final String email;
  final String plano;

  UsuarioModel({
    required this.id,
    required this.firebaseUid,
    required this.nome,
    required this.email,
    required this.plano,
  });

  // Factory para converter o JSON que vem do teu endpoint /auth/sync
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int,
      firebaseUid: json['firebase_uid'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      plano: json['plano'] as String,
    );
  }
}