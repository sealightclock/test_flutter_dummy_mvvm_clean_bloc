import 'package:flutter/material.dart';

import 'presentation/view/my_string_home_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Fix: Added key parameter to avoid
  // a warning about a named 'key' parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Flutter App with MVI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStringHomeScreen(),
    );
  }
}
