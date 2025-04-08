import 'package:hive_flutter/hive_flutter.dart';

/// Helper to reset Hive database for clean integration testing.
Future<void> resetHive() async {
  // Initialize Hive (only if not already initialized)
  try {
    await Hive.initFlutter();
  } catch (_) {
    // Ignore if already initialized
  }

  // List of all known box names you use in the app
  const boxNames = [
    'user_auth_box', // Auth feature
    'my_string_hive_box', // MyString feature
  ];

  // Delete contents of each box
  for (final boxName in boxNames) {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      await box.clear();
      await box.close();
    } else {
      final box = await Hive.openBox(boxName);
      await box.clear();
      await box.close();
    }
  }
}
