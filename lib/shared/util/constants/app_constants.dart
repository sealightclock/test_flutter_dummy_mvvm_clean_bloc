/// Central place to define all string constants used across the core.
///
/// Helps improve consistency, prevents hardcoded strings everywhere,
/// and makes localization easier in the future.
class AppConstants {
  // ---------------------------------------------------------------------------
  // Default Values (used when local storage returns null)
  // ---------------------------------------------------------------------------

  static const String defaultValueHive = 'Default Value from Hive';
  static const String defaultValueSharedPrefs = 'Default Value from SharedPreferences';

  // ---------------------------------------------------------------------------
  // Enum Display Labels (used for UI/debug/logging for DI config)
  // ---------------------------------------------------------------------------

  static const String localStoreLabelHive = 'Hive';
  static const String localStoreLabelSharedPrefs = 'SharedPreferences';

  static const String remoteServerLabelSimulator = 'Simulator';
  static const String remoteServerLabelDio = 'Dio';
  static const String remoteServerLabelHttp = 'Http';

  // ---------------------------------------------------------------------------
  // UI Labels for MyStringScreen (used in text fields, buttons, hints)
  // ---------------------------------------------------------------------------

  static const String enterStringLabel = 'Enter string';
  static const String updateFromUserLabel = 'Update from User';
  static const String updateFromServerLabel = 'Update from Server';
  static const String currentValueLabel = 'Current Value:';
  static const String initialHintText = 'Enter or load a string to begin';

  // ---------------------------------------------------------------------------
  // UI Labels for SettingsScreen
  // ---------------------------------------------------------------------------
  static const String settingsDartModeLabel = 'Dart Mode';
  static const String settingsFontSizeLabel = 'Font Size';

  // ---------------------------------------------------------------------------
  // DI Section Headers for MyStringScreen (top of screen)
  // ---------------------------------------------------------------------------

  static const String localStoragePrefix = 'Local Storage: ';
  static const String remoteServerPrefix = 'Remote Server: ';

  // ---------------------------------------------------------------------------
  // Box and Key definitions
  // ---------------------------------------------------------------------------

  static const String appHiveBoxName = 'app_hive_box';
  static const String appLastSeenTabKey = 'app_last_seen_tab_key';

  static const String authHiveBoxName = 'auth_hive_box';
  static const String authKey = 'auth_key';

  static const String myStringHiveBoxName = 'my_string_hive_box';
  static const String myStringKey = 'my_string_key';

  // TODO: account

  static const String settingsHiveBoxName = 'settings_hive_box';
  static const String settingsKey = 'settings_key';

  // TODO: BLE
  // TODO: Status

  // ---------------------------------------------------------------------------
  // ...
  // ---------------------------------------------------------------------------

  static const String backendServerUrl = 'http://example.com';

  static const String prefixHttpValue = 'MyStringHttpDataSource: Server '
      'String: ';
  static const String prefixDioValue = 'MyStringDioDataSource: Server String: ';
  static const String prefixSimulationValue = 'MyStringSimulatorDataSource: '
      'Mocked Server String: ';

  static const int simulatorDelaySeconds = 10; // Simulate network delay.
}
