import 'package:flutter/material.dart';
import 'app_restarter.dart';

/// Custom widget that wraps the entire app and allows full rebuilds on demand.
///
/// Why do we need this layer?
/// - Without this wrapper, changing app-wide settings (like theme) requires a full relaunch.
/// - By wrapping the MaterialApp inside a `KeyedSubtree`, we can trigger rebuilds by changing the key.
/// - This enables dynamic theme switching and other UI-wide config changes — without restarting the app.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

/// State class to manage rebuildable app wrapper.
class MyAppState extends State<MyApp> {
  // Unique key to force full rebuild of MaterialApp and everything under it
  Key _appWrapperKey = UniqueKey();

  /// Call this method to trigger a full rebuild of the app.
  /// It simulates an "app restart" without restarting Flutter engine.
  void triggerRebuild() {
    setState(() {
      _appWrapperKey = UniqueKey(); // Changes the key to trigger full rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _appWrapperKey,
      child: const AppRestarter(), // Inner app logic, includes Blocs and theme
    );
  }
}
