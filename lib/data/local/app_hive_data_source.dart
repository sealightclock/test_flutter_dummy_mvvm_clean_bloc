import 'package:hive_flutter/hive_flutter.dart';

/// Enum representing the last screen the user visited.
/// This allows us to restore the UI to the last seen screen on app relaunch.
enum LastSeenTab {
  auth,
  myString,
  account,
  settings,
}

/// Helper class to persist and restore the last seen screen (AppTab)
///
/// This uses Hive to save the value to disk.
/// Called automatically by HomeScreen logic on tab switch and startup.
///
/// The saved enum value will be restored during app launch to improve UX.
class AppHiveDataSource {
  // Hive box name and key for this feature
  static const String _boxName = 'last_seen_tab_box';
  static const String _key = 'last_tab';

  static bool _initialized = false;

  /// Ensure Hive is initialized and the box is opened before use.
  ///
  /// ❗ Without this, we may get runtime errors in integration tests or on real devices.
  static Future<void> _initIfNeeded() async {
    if (!_initialized) {
      await Hive.initFlutter(); // ✅ Safe to call multiple times
      await Hive.openBox<String>(_boxName);
      _initialized = true;
    }
  }

  /// Save the selected tab (as enum string) into Hive for persistence.
  static Future<void> saveTab(LastSeenTab tab) async {
    await _initIfNeeded();
    final box = Hive.box<String>(_boxName);
    await box.put(_key, tab.name); // Store as string
  }

  /// Load the last seen tab from Hive, defaulting to auth if none saved.
  static Future<LastSeenTab> getLastSeenTab() async {
    await _initIfNeeded();
    final box = Hive.box<String>(_boxName);
    final savedName = box.get(_key);
    return LastSeenTab.values.firstWhere(
          (e) => e.name == savedName,
      orElse: () => LastSeenTab.auth,
    );
  }
}
