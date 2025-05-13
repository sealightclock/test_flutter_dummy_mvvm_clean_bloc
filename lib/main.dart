import 'package:flutter/material.dart';

import 'app.dart';

/// Entry point of the Flutter app.
///
/// This file is intentionally kept minimal for clarity and testability.
/// It simply launches the app using a global key to enable full UI rebuilds
/// when needed (e.g. after user updates settings).
final GlobalKey<MyAppState> appKey = GlobalKey();

void main() {
  runApp(MyApp(key: appKey));
}

/// 🔄 Used to trigger a full UI rebuild from anywhere in the app.
///
/// This is helpful when user changes app-wide settings like:
/// - Theme mode (light/dark)
/// - Font size
///
/// This rebuild is *not* a full app relaunch — it just resets the widget tree.
void triggerAppRebuild() {
  appKey.currentState?.restart();
}
