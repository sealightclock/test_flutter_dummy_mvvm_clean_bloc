import 'package:hive_flutter/hive_flutter.dart';

import '../../../features/auth/domain/entity/auth_entity.dart';
import '../../../features/my_string/domain/entity/my_string_entity.dart';
import '../../../features/settings/domain/entity/settings_entity.dart';

/// Utility class to centralize Hive initialization and operations.
///
/// Helps reduce duplication across features (DRY), improves testability,
/// and avoids inconsistent behavior.
///
/// Example usage:
/// ```dart
/// await HiveUtils.init();
/// final box = await HiveUtils.openBox<String>('box_name');
/// await HiveUtils.clearBox('box_name');
/// ```
class HiveUtils {
  static bool _isInitialized = false;

  /// Ensures Hive is initialized exactly once.
  static Future<void> init() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      _isInitialized = true;
    }

    registerAdapters(); // ✅ Ensure all adapters are registered
  }

  /// Centralized registration for all Hive adapters.
  ///
  /// This ensures adapters are registered once app-wide.
  static void registerAdapters() {
    if (!Hive.isAdapterRegistered(AuthEntityAdapter().typeId)) {
      Hive.registerAdapter(AuthEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(MyStringEntityAdapter().typeId)) {
      Hive.registerAdapter(MyStringEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(SettingsEntityAdapter().typeId)) {
      Hive.registerAdapter(SettingsEntityAdapter());
    }

    // TODO: Add more adapters here in future (e.g., AppAdapter, AccountAdapter)
  }

  /// Open a typed box after ensuring Hive is initialized.
  static Future<Box<T>> openBox<T>(String boxName) async {
    await init();
    return Hive.openBox<T>(boxName);
  }

  /// Clear the contents of a Hive box.
  static Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  /// Delete a specific key from a box.
  static Future<void> deleteKey(String boxName, dynamic key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }
}
