import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/theme/app_theme.dart'; // <-- NEW import for shared theme

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Testability for integration testing
    // Use RootRestorationScope to support widget lifecycle restore
    return RootRestorationScope(
      restorationId: 'root',
      child: MaterialApp(
        title: 'MVVM Clean + Bloc Demo',
        restorationScopeId: 'app', // Testability for integration testing
        theme: AppTheme.lightTheme, // <-- Use our shared app theme
        home: const MyStringHomeScreen(),
      ),
    );
  }
}
