import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/settings/domain'
    '/entity/settings_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/app_constants.dart';

class SettingsHiveDataSource {
  /// Initialize Hive and register the adapter for SettingsEntity
  Future<void> init() async {
    // ✅ Initialize Hive if not already initialized
    if (!Hive.isBoxOpen(AppConstants.settingsHiveBoxName)) {
      // Prevent multiple initializations
      if (!Hive.isAdapterRegistered(SettingsEntityAdapter().typeId)) {
        Hive.registerAdapter(SettingsEntityAdapter());
      }

      // This is the crucial fix: initialize Hive with a directory
      await Hive.initFlutter();

      await Hive.openBox<SettingsEntity>(AppConstants.settingsHiveBoxName);
    }
  }

  /// Retrieve stored settings or return default
  Future<SettingsEntity> getSettings() async {
    await init();
    final box = Hive.box<SettingsEntity>(AppConstants.settingsHiveBoxName);
    return box.get(AppConstants.settingsKey) ?? SettingsEntity(darkMode: false,
        fontSize: 16.0);
  }

  /// Save updated settings to Hive
  Future<void> saveSettings(SettingsEntity settings) async {
    await init();
    final box = Hive.box<SettingsEntity>(AppConstants.settingsHiveBoxName);
    await box.put(AppConstants.settingsKey, settings);
  }
}
