import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'root_screen.dart';

/// The root widget of the app, wrapped with BlocProviders.
///
/// - It listens to settings changes (like dark mode, font size)
/// - It builds the MaterialApp with the correct theme
/// - It wraps the RootScreen which controls navigation across features
///
/// This class is also restartable using `triggerAppRebuild()`
/// by updating its internal key (see `_MyAppState`).
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

/// State class for [MyApp] that supports full subtree rebuild.
class MyAppState extends State<MyApp> {
  // This key is used to restart the subtree when settings change
  Key appKey = UniqueKey();

  /// Call this method to trigger a full UI rebuild.
  ///
  /// 🔁 Used by `triggerAppRebuild()` defined in main.dart
  void restart() {
    if (mounted) { // TODO: This check may not be needed.
      setState(() {
        appKey = UniqueKey(); // Forces full rebuild of subtree
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: appKey,
      child: RootRestorationScope( // ✅ Improves integration testability
        restorationId: 'root',
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc()..add(const AuthUnauthenticatedEvent()),
            ),
            BlocProvider<SettingsBloc>(
              create: (_) => SettingsBloc()..add(SettingsLoadEvent()),
            ),
          ],
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final settings = state is SettingsLoadedOrUpdatedState ? state.settings : null;

              // Build theme based on user settings, fallback if null
              final theme = settings?.darkMode ?? false
                  ? AppTheme.darkThemeWithFontSize(settings?.fontSize ?? 16.0)
                  : AppTheme.lightThemeWithFontSize(settings?.fontSize ?? 16.0);

              return MaterialApp(
                title: 'Flutter MVVM Clean + Bloc Demo',
                restorationScopeId: 'app', // Helps in restoring state after app restarts
                theme: theme,
                home: const RootScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
