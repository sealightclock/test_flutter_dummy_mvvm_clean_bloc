import 'package:flutter/material.dart';
import 'app.dart'; // Entry point to the main app UI and logic

// ✅ This key allows restarting the entire app programmatically.
// Used mainly for testing and for applying settings (e.g. dark mode) without full relaunch.
final GlobalKey<MyAppState> appKey = GlobalKey();

void main() {
  // ✅ Root of the app — starts MyApp which can restart itself.
  runApp(MyApp(key: appKey));
}

/// Global method to restart app.
///
/// This is called when settings change (e.g., dark mode toggle),
/// so the entire widget tree can rebuild using the new settings.
///
/// 🧪 This is not usually needed in production unless dynamic theme/font/etc.
///      changes must apply instantly.
void restartApp() {
  appKey.currentState?.restart();
}
