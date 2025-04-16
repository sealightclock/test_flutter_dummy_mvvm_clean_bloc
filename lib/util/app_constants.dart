/// Central place to define all string constants used across the app.
///
/// Helps improve consistency and prevents hardcoded strings everywhere.
class AppConstants {
  static const String defaultValueHive = 'Default Value from Hive';
  static const String defaultValueSharedPrefs = 'Default Value from SharedPreferences';

  // Labels for enum display (UI/debug/logging)
  static const String localStoreLabelHive = 'Hive';
  static const String localStoreLabelSharedPrefs = 'SharedPreferences';

  static const String remoteServerLabelSimulator = 'Simulator';
  static const String remoteServerLabelDio = 'Dio';
  static const String remoteServerLabelHttp = 'Http';
}
