import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entity/settings_entity.dart';

class SettingsLocalDataSource {
  static const String _boxName = 'settings_box';
  static const String _key = 'settings';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(SettingsEntityAdapter().typeId)) {
      Hive.registerAdapter(SettingsEntityAdapter());
    }
    await Hive.openBox<SettingsEntity>(_boxName);
  }

  Future<SettingsEntity> getSettings() async {
    final box = await Hive.openBox<SettingsEntity>(_boxName);
    return box.get(_key) ?? SettingsEntity(darkMode: false, fontSize: 16.0);
  }

  Future<void> saveSettings(SettingsEntity settings) async {
    final box = await Hive.openBox<SettingsEntity>(_boxName);
    await box.put(_key, settings);
  }
}
