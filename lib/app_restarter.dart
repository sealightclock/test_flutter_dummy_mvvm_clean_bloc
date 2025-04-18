
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'home_screen.dart';
import 'theme/app_theme.dart';

class AppRestarter extends StatefulWidget {
  const AppRestarter({super.key});

  @override
  State<AppRestarter> createState() => _AppRestarterState();
}

class _AppRestarterState extends State<AppRestarter> {

  @override
  Widget build(BuildContext context) {
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
            final settings = state is SettingsLoaded ? state.settings : null;
            final theme = settings?.darkMode ?? false
                ? AppTheme.darkThemeWithFontSize(settings?.fontSize ?? 16.0)
                : AppTheme.lightThemeWithFontSize(settings?.fontSize ?? 16.0);

            return MaterialApp(
              key: ValueKey(settings?.darkMode.toString() ?? 'light'),
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
