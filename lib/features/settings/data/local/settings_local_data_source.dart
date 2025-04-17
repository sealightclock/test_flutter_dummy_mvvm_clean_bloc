import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entity/settings_entity.dart';

/// Local data source for storing and retrieving user settings (dark mode, font size).
///
/// Uses Hive for persistence and ensures the adapter is registered before any access.
class SettingsLocalDataSource {
  static const String _boxName = 'settings_box';
  static const String _key = 'settings';

  /// Ensures the Hive adapter is registered and the box is open.
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(SettingsEntityAdapter().typeId)) {
      Hive.registerAdapter(SettingsEntityAdapter());
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<SettingsEntity>(_boxName);
    }
  }

  /// Retrieves user settings from Hive, or provides default values if missing.
  Future<SettingsEntity> getSettings() async {
    await init(); // ✅ Ensure adapter is registered before access

    final box = Hive.box<SettingsEntity>(_boxName);
    return box.get(_key) ?? const SettingsEntity(darkMode: false, fontSize: 16.0);
  }

  /// Saves user settings to Hive.
  Future<void> saveSettings(SettingsEntity settings) async {
    await init(); // ✅ Ensure adapter is registered before write

    final box = Hive.box<SettingsEntity>(_boxName);
    await box.put(_key, settings);
  }
}
