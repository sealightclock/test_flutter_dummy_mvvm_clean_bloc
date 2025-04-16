import '../../../util/app_constants.dart';

/// Enum to select which Local Store to use
enum LocalStore {
  sharedPrefs,
  hive;

  /// Returns label for display/debug
  String get label {
    switch (this) {
      case LocalStore.sharedPrefs:
        return AppConstants.localStoreLabelSharedPrefs;
      case LocalStore.hive:
        return AppConstants.localStoreLabelHive;
    }
  }
}
