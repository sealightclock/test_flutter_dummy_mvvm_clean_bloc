import 'package:test_flutter_dummy_mvvm_clean_bloc/util/app_constants.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/hive_utils.dart';

/// Enum representing the last screen the user visited.
/// This allows us to restore the UI to the last seen screen on app relaunch.
enum LastSeenTab {
  auth,
  myString,
  account,
  settings,
}

/// App-wide Hive data source to manage global values like last seen screen.
///
/// This follows DRY principles by leveraging shared [HiveUtils] for consistency.
class AppHiveDataSource {
  /// Save the selected tab (as enum string) into Hive for persistence.
  static Future<void> saveTab(LastSeenTab tab) async {
    final box = await HiveUtils.openBox<String>(AppConstants.appHiveBoxName);
    await box.put(AppConstants.appKey, tab.name); // Store as string
  }

  /// Load the last seen tab from Hive, defaulting to auth if none saved.
  static Future<LastSeenTab> getLastSeenTab() async {
    final box = await HiveUtils.openBox<String>(AppConstants.appHiveBoxName);
    final savedName = box.get(AppConstants.appKey);
    return LastSeenTab.values.firstWhere(
          (e) => e.name == savedName,
      orElse: () => LastSeenTab.auth,
    );
  }
}
