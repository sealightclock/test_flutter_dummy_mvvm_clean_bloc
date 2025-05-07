import 'dart:io';

// TODO: The following code is copied from somewhere.
//   I do not think an Android user app has the privilege to uninstall any
//   app including itself.
//   We should remove this code.

/// Uninstalls the app from the connected device before testing (only on Android).
///
/// Ensures a clean app state including all Hive and cache files.
Future<void> uninstallFlutterApp(String packageName) async {
  if (!Platform.isAndroid) {
    print('ℹ️ adb uninstall skipped: Not running on Android.');
    return;
  }

  try {
    final result = await Process.run('adb', ['uninstall', packageName]);

    if (result.exitCode == 0) {
      print('✅ Uninstalled $packageName before test.');
    } else {
      print('⚠️ adb uninstall failed or app not installed: ${result.stderr}');
    }
  } catch (e) {
    print('⚠️ adb uninstall failed: \n$e');
  }
}
