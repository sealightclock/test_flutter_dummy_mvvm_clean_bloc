import 'package:flutter/material.dart';

import 'app_restarter.dart';

/// Custom app-level widget that can rebuild the app
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Key appWrapperKey = UniqueKey();

  void restart() {
    setState(() {
      appWrapperKey = UniqueKey(); // Forces full subtree rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: appWrapperKey,
      child: const AppRestarter(),
    );
  }
}
