
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/view/my_string_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/root_screen.dart';

/// Utility class to help launching the core during integration tests.
///
/// Usage:
/// ```dart
/// final launcher = TestAppLauncher(tester);
/// await launcher.launchApp();
/// await launcher.prepareBloc();  // When on MyString screen
/// ```
class TestAppLauncher {
  final WidgetTester tester;
  late MyStringBloc bloc;

  TestAppLauncher(this.tester);

  /// Launch core with AuthBloc pre-configured to skip manual login.
  Future<void> launchApp() async {
    await tester.pumpWidget(const MyAppForTesting());
    await tester.pumpAndSettle();
  }

  /// Waits until MyStringScreenBody is found, and extracts its Bloc.
  Future<void> prepareBloc() async {
    final myStringBodyFinder = find.byType(MyStringScreenBody);

    const timeout = Duration(seconds: 10);
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pumpAndSettle();
      if (myStringBodyFinder.evaluate().isNotEmpty) {
        final state = tester.firstState<MyStringScreenBodyState>(myStringBodyFinder);
        bloc = state.exposedBloc;
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    fail('❌ MyStringScreenBody not found within ${timeout.inSeconds} seconds.');
  }

  Future<void> refreshAfterRestart() => prepareBloc();
}

/// Dummy test core with AuthBloc pre-initialized for guest login
class MyAppForTesting extends StatelessWidget {
  const MyAppForTesting({super.key});

  @override
  Widget build(BuildContext context) {
    // Force guest login to bypass Auth screen
    final authBloc = AuthBloc()..add(const AuthGuestAuthenticatedEvent());

    return BlocProvider<AuthBloc>(
      create: (_) => authBloc,
      child: const MaterialApp(
        home: RootScreen(),
      ),
    );
  }
}
