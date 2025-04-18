import 'package:flutter/material.dart';

import 'app_restarter.dart'; // Contains the actual app content (MaterialApp + Bloc providers)

/// This top-level widget wraps the entire app and allows for a complete rebuild.
///
/// WHY is this needed?
/// - When certain user settings (like Dark Mode or Font Size) change,
///   Flutter normally does NOT rebuild the entire widget tree.
/// - To force a full rebuild and apply new themes instantly, we need to create
///   a wrapper that can be "restarted" by changing its key.
///
/// HOW it works:
/// - This class holds a mutable `Key` called `appWrapperKey`.
/// - When `restart()` is called, the key is changed using `UniqueKey()`,
///   which forces a rebuild of everything below this widget.
/// - This includes the MaterialApp and any dependent UI logic.
///
/// This pattern is useful for themes, localization, or any global app-wide setting.
///
/// In production apps:
/// - This kind of global restarter may not be necessary if settings are applied differently.
/// - We use this for testability, flexibility, and dynamic UI responsiveness.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

/// Internal state of [MyApp] that manages the rebuild trigger logic.
class MyAppState extends State<MyApp> {
  // This key is what causes the entire subtree (below MyApp) to restart.
  // We change it using setState when restart() is called.
  Key appWrapperKey = UniqueKey();

  /// Call this to force the entire app to restart.
  /// Used when settings like dark mode or font size are changed.
  void restart() {
    setState(() {
      appWrapperKey = UniqueKey(); // Forces full subtree rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the actual app in a KeyedSubtree so we can rebuild on demand
    return KeyedSubtree(
      key: appWrapperKey,
      child: const AppRestarter(), // AppRestarter builds MaterialApp + Bloc + Theme
    );
  }
}
