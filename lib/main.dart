import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';

// Testability for integration testing
Future<void> main() async {
  runApp(const MyApp());
}

// Testability for integration testing
Future<void> startApp(Widget app) async {
  runApp(app);
}
