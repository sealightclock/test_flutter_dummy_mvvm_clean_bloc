import '../../../util/app_constants.dart';
import '../../../util/hive_utils.dart';
import 'app_tab_enum.dart';

/// App-wide Hive data source to manage global values like last seen screen.
///
/// This follows DRY principles by leveraging shared [HiveUtils] for consistency.
class AppHiveDataSource {
  /// Save the selected tab (as enum string) into Hive for persistence.
  static Future<void> saveLastSeenTab(AppTab tab) async {
    final box = await HiveUtils.openBox<String>(AppConstants.appHiveBoxName);
    await box.put(AppConstants.appLastSeenTabKey, tab.name); // Store as string
  }

  /// Load the last seen tab from Hive, defaulting to auth if none saved.
  static Future<AppTab> getLastSeenTab() async {
    final box = await HiveUtils.openBox<String>(AppConstants.appHiveBoxName);
    final savedName = box.get(AppConstants.appLastSeenTabKey);
    return AppTab.values.firstWhere(
          (e) => e.name == savedName,
      orElse: () => AppTab.auth,
    );
  }
}
