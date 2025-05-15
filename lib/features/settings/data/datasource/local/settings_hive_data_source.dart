import '../../../../../shared/util/constants/app_constants.dart';
import '../../../../../shared/util/hive/hive_utils.dart';
import '../../../domain/entity/settings_entity.dart';

/// Data source to manage reading and writing core settings using Hive.
///
/// This class delegates Hive initialization and adapter registration
/// to [HiveUtils] for simplicity and consistency across the core.
class SettingsHiveDataSource {
  /// Retrieve settings from Hive or return a default instance.
  Future<SettingsEntity> getSettings() async {
    final box = await HiveUtils.openBox<SettingsEntity>(AppConstants.settingsHiveBoxName);
    return box.get(AppConstants.settingsKey) ??
        const SettingsEntity(darkMode: false, fontSize: 16.0);
  }

  /// Save updated settings to Hive.
  Future<void> saveSettings(SettingsEntity settings) async {
    final box = await HiveUtils.openBox<SettingsEntity>(AppConstants.settingsHiveBoxName);
    await box.put(AppConstants.settingsKey, settings);
  }
}
