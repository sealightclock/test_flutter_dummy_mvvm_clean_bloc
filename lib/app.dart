import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/view/auth_screen.dart';

import 'features/my_string/presentation/theme/app_theme.dart';

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
        restorationScopeId: 'app', // Unique ID for restoration
        theme: AppTheme.lightTheme, // Shared app theme (light mode for now)

        // Set the initial screen as AuthScreen
        home: BlocProvider(
          create: (_) => AuthCubit(),
          child: const AuthScreen(),
        ),
      ),
    );
  }
}
