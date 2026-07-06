import 'package:health/health.dart';

// ─── Integração HealthKit (iOS) / Health Connect (Android) ─────────────────
//
// O pacote `health` unifica os dois: no iOS ele fala com o Apple HealthKit,
// no Android com o Health Connect (o Google descontinuou a API antiga do
// Google Fit em 2024, então "Health Connect" é o caminho oficial hoje).
//
// IMPORTANTE — configuração nativa necessária (não dá pra fazer só em
// Dart, precisa mexer nos projetos nativos):
//
// ANDROID (android/app/src/main/AndroidManifest.xml):
//   <queries>
//     <package android:name="com.google.android.apps.healthdata" />
//     <intent>
//       <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" />
//     </intent>
//   </queries>
//   + adicionar as permissões de leitura de BPM/passos (ver documentação do
//     pacote `health` para a lista completa de `uses-permission`).
//
// ANDROID (android/app/src/main/kotlin/.../MainActivity.kt):
//   A MainActivity precisa estender `FlutterFragmentActivity` em vez de
//   `FlutterActivity`, senão a tela de permissões do Health Connect não
//   abre. Também é preciso ter o app "Health Connect" instalado no
//   aparelho/emulador (no Android 14+ já vem de fábrica).
//
// iOS (Xcode → Runner → Signing & Capabilities):
//   Adicionar a capability "HealthKit".
//   Atenção: o HealthKit só libera dados com o aparelho desbloqueado — em
//   testes muito cedo após o boot pode falhar mesmo com permissão OK.
//
// SEM essa configuração nativa, os métodos abaixo vão falhar silenciosamente
// (retornam false/null) — por isso toda a MonitorScreen já foi escrita para
// cair de volta no BPM simulado (`Random()`) quando a integração não
// responde, em vez de travar a tela.

class HealthService {
  static final Health _health = Health();
  static bool _configured = false;

  static const List<HealthDataType> _types = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
  ];

  static Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  /// Pede permissão de leitura de BPM/passos. Retorna false se o usuário
  /// negar, se o Health Connect/HealthKit não estiver disponível, ou se a
  /// configuração nativa (manifest/entitlements) ainda não foi feita.
  static Future<bool> requestPermissions() async {
    await _ensureConfigured();
    try {
      final alreadyGranted = await _health.hasPermissions(_types) ?? false;
      if (alreadyGranted) return true;
      return await _health.requestAuthorization(_types);
    } catch (_) {
      return false;
    }
  }

  /// Busca o BPM mais recente registrado nas últimas 6 horas.
  /// Retorna null se não houver dado, sem permissão, ou se algo falhar.
  static Future<int?> fetchLatestHeartRate() async {
    await _ensureConfigured();
    try {
      final now = DateTime.now();
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: now.subtract(const Duration(hours: 6)),
        endTime: now,
      );
      if (data.isEmpty) return null;

      data.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      final value = data.first.value;
      if (value is NumericHealthValue) {
        return value.numericValue.round();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Total de passos de hoje (meia-noite até agora).
  static Future<int?> fetchTodaySteps() async {
    await _ensureConfigured();
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      return await _health.getTotalStepsInInterval(midnight, now);
    } catch (_) {
      return null;
    }
  }
}
