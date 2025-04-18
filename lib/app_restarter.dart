import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'home_screen.dart';
import 'theme/app_theme.dart';

/// This widget is the main part of the app that wires up:
/// - BLoC state management (Auth and Settings)
/// - App-wide Theme using current settings (e.g. dark mode, font size)
/// - RootRestorationScope for testability
///
/// ⚠️ This widget is wrapped by `MyApp` in main.dart, which uses a key to
/// force a full app rebuild when needed (e.g. after settings change).
class AppRestarter extends StatefulWidget {
  const AppRestarter({super.key});

  @override
  State<AppRestarter> createState() => _AppRestarterState();
}

class _AppRestarterState extends State<AppRestarter> {
  @override
  Widget build(BuildContext context) {
    return RootRestorationScope(
      restorationId: 'root', // ✅ Required for restoring widget state during tests
      child: MultiBlocProvider(
        providers: [
          // 🔐 Provide AuthBloc to manage user login/logout/guest logic
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc()..add(const AuthUnauthenticatedEvent()),
          ),

          // ⚙️ Provide SettingsBloc to manage app settings (e.g. dark mode)
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc()..add(LoadSettingsEvent()),
          ),
        ],

        // 🎨 Listen to SettingsBloc state changes to apply theme
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final settings = state is SettingsLoaded ? state.settings : null;

            // Choose theme based on settings or fallback to light mode
            final theme = settings?.darkMode ?? false
                ? AppTheme.darkThemeWithFontSize(settings?.fontSize ?? 16.0)
                : AppTheme.lightThemeWithFontSize(settings?.fontSize ?? 16.0);

            return MaterialApp(
              key: ValueKey(settings?.darkMode.toString() ?? 'light'),
              title: 'Flutter MVVM Clean + Bloc Demo',
              restorationScopeId: 'app', // Used for state restoration in tests
              theme: theme, // Apply dynamic theme
              home: const HomeScreen(), // App entry screen
            );
          },
        ),
      ),
    );
  }
}
