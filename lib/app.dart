import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Testability for integration testing
    return RootRestorationScope(
      restorationId: 'root',
      child: MaterialApp(
        title: 'MVVM Clean + Bloc Demo',
        restorationScopeId: 'app', // Testability for integration testing
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const MyStringHomeScreen(),
      ),
    );
  }
}
