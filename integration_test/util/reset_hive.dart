import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Helper to reset Hive database for clean integration testing.
///
/// Dynamically clears + deletes known boxes.
/// No reliance on removed APIs like `Hive.boxes`.
Future<void> resetHive() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final hiveDir = Directory('${dir.path}/hive_boxes');

    if (await hiveDir.exists()) {
      await hiveDir.delete(recursive: true);
    }
  } catch (e) {
    // Ignore errors - usually happens if directory is already clean
  }

  // ✅ List of manually known box names
  const knownBoxNames = [
    'user_auth_box',
    'my_string_hive_box',
  ];

  for (final boxName in knownBoxNames) {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.clear();
        await box.close();
      }
      await Hive.deleteBoxFromDisk(boxName);
    } catch (_) {
      // Ignore
    }
  }
}
