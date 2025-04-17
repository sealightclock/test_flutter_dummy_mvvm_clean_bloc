import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'home_screen.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Testability for integration testing
    // Use RootRestorationScope to support widget lifecycle restore
    return RootRestorationScope(
      restorationId: 'root',
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc()..add(const AuthUnauthenticatedEvent()),
          ),
          BlocProvider(
            create: (_) => SettingsBloc()..add(LoadSettingsEvent()),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            // 🌓 Dynamically choose theme based on user settings
            final useDark = (state is SettingsLoaded && state.settings.darkMode);

            return MaterialApp(
              title: 'Flutter MVVM Clean + Bloc Demo',
              restorationScopeId: 'app',
              theme: useDark ? ThemeData.dark(useMaterial3: true) : AppTheme.lightTheme,

              // Set the initial screen as HomeScreen with BottomNavigationBar
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
