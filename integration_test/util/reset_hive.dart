import 'package:hive_flutter/hive_flutter.dart';

/// Helper to reset Hive database for clean integration testing.
///
/// Dynamically clears + deletes known boxes.
/// No reliance on removed APIs like `Hive.boxes`.
Future<void> resetHive() async {
  // Initialize Hive (only if not already initialized)
  try {
    await Hive.initFlutter();
  } catch (_) {
    // Ignore if already initialized
  }

  // ✅ List of manually known box names
  const knownBoxNames = [
    'user_auth_box',
    'my_string_hive_box',
  ];

  // Reset each box safely
  for (final boxName in knownBoxNames) {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.clear();
        await box.close();
      } else {
        final box = await Hive.openBox(boxName);
        await box.clear();
        await box.close();
      }

      // 🧹 Delete box file from disk to fully reset
      await Hive.deleteBoxFromDisk(boxName);
    } catch (e) {
      // Ignore any missing/corrupted box errors
    }
  }
}
