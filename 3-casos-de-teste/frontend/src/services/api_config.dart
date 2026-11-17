// lib/src/services/api_config.dart
//
// Centraliza a URL base do backend. Se o endereço mudar (ex: deploy em
// produção), só precisa alterar aqui — nenhum outro arquivo precisa saber.


  // Rodando com `flutter run -d chrome`, o navegador acessa o backend
  // local normalmente em localhost, então essa URL funciona direto.
  //
  // Se um dia for testar em emulador Android, troque para:
  //   http://10.0.2.2:3000
  // Se for testar em celular físico, troque para o IP da sua máquina:
  //   http://192.168.0.X:3000
class ApiConfig {
  static const String baseUrl = 'http://localhost:3000';
}
