import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entity/settings_entity.dart';

class SettingsLocalDataSource {
  static const String _boxName = 'settings_box';
  static const String _key = 'settings';

  /// Initialize Hive and register the adapter for SettingsEntity
  Future<void> init() async {
    // ✅ Initialize Hive if not already initialized
    if (!Hive.isBoxOpen(_boxName)) {
      // Prevent multiple initializations
      if (!Hive.isAdapterRegistered(SettingsEntityAdapter().typeId)) {
        Hive.registerAdapter(SettingsEntityAdapter());
      }

      // This is the crucial fix: initialize Hive with a directory
      await Hive.initFlutter();

      await Hive.openBox<SettingsEntity>(_boxName);
    }
  }

  /// Retrieve stored settings or return default
  Future<SettingsEntity> getSettings() async {
    await init();
    final box = Hive.box<SettingsEntity>(_boxName);
    return box.get(_key) ?? SettingsEntity(darkMode: false, fontSize: 16.0);
  }

  /// Save updated settings to Hive
  Future<void> saveSettings(SettingsEntity settings) async {
    await init();
    final box = Hive.box<SettingsEntity>(_boxName);
    await box.put(_key, settings);
  }
}
