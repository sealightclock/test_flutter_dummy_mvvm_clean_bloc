import 'package:flutter/material.dart';

import 'features/my_string/presentation/theme/app_theme.dart';
import 'features/my_string/presentation/view/my_string_home_screen.dart';

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
