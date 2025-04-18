import 'package:flutter/material.dart';
import 'app.dart';

/// Global key to access internal state of MyApp,
/// which enables us to force a rebuild of the whole app.
final GlobalKey<MyAppState> appKey = GlobalKey();

/// Entry point of the app.
/// This is called when the app is launched or relaunched (Scenario 1).
void main() {
  runApp(MyApp(key: appKey));
}

/// Global method to force a UI-level rebuild of the app (Scenario 2).
///
/// Why do we need this?
/// - Certain user settings (e.g. dark mode) affect the whole UI.
/// - To reflect those changes immediately, we need to rebuild the full widget tree.
/// - Instead of using heavy solutions like RestartableApp or rebuild-from-main,
///   this lightweight method gives us full control without leaving Flutter.
///
/// ⚠️ This does *not* restart the app. It only rebuilds the widget subtree from MyApp.
void triggerAppRebuild() {
  appKey.currentState?.triggerRebuild();
}
