import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';

Future<void> mainForTest() async {
  runApp(const MyApp());
}

// Still keep the real main() untouched
void main() {
  runApp(const MyApp());
}
