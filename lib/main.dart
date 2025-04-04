import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';

// Testability for integration testing
// Use Future + async to make widget tests work:
Future<void> main() async {
  runApp(const MyApp());
}

// Testability for integration testing
// startApp() will be used by integration tests.
Future<void> startApp(Widget app) async {
  runApp(app);
}
