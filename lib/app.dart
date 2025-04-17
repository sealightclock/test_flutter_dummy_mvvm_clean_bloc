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
    // RootRestorationScope improves integration testability
    return RootRestorationScope(
      restorationId: 'root',
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc()..add(const AuthUnauthenticatedEvent()),
          ),
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc()..add(LoadSettingsEvent()),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            // Default theme if not loaded yet
            ThemeData theme = AppTheme.lightThemeWithFontSize(16.0);

            if (state is SettingsLoaded) {
              theme = state.settings.darkMode
                  ? AppTheme.darkThemeWithFontSize(state.settings.fontSize)
                  : AppTheme.lightThemeWithFontSize(state.settings.fontSize);
            }

            return MaterialApp(
              title: 'Flutter MVVM Clean + Bloc Demo',
              restorationScopeId: 'app',
              theme: theme,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
