// lib/src/services/api_config.dart
//
// Centraliza a URL base do backend. Se o endereço mudar (ex.: deploy em
// produção), só é necessário alterar aqui — nenhum outro arquivo precisa
// saber disso.
//
// Valor padrão (http://10.0.2.2:3000) é o endereço que o emulador Android
// usa para acessar o "localhost" da máquina host, onde o backend roda em
// desenvolvimento.
//   • Rodando com `flutter run -d chrome`: o navegador acessa o backend
//     local diretamente, então pode-se usar http://localhost:3000.
//   • Testando em um celular físico na mesma rede: use o IP local da
//     máquina que roda o backend, ex.: http://192.168.0.X:3000.
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:3000';
}