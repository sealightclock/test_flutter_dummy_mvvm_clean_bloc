/// App-wide constants shared across features and layers.
///
/// Keeping constants in one place improves consistency, helps debugging,
/// and makes localization easier in the future.
///
/// TIP: Use different values for each data source to quickly identify bugs.
class AppConstants {
  /// Default string returned from Hive local store
  static const String defaultValueFromHive = 'Default Value from Hive';

  /// Default string returned from SharedPreferences local store
  static const String defaultValueFromSharedPrefs = 'Default Value from SharedPreferences';

// Add more constants as needed for remote servers, simulators, etc.
}
