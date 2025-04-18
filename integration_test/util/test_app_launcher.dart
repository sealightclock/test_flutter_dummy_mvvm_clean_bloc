// integration_test/util/test_app_launcher.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/view/my_string_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/home_screen.dart';

/// Utility class to help launching the app during integration tests.
///
/// Usage:
/// ```dart
/// final launcher = TestAppLauncher(tester);
/// await launcher.launchApp();
/// await launcher.prepareBloc();  // When on MyString screen
/// ```
class TestAppLauncher {
  final WidgetTester tester;

  late MyStringBloc bloc; // Exposes MyStringBloc instance for testing

  TestAppLauncher(this.tester);

  /// Launches the app inside a MaterialApp with AuthBloc support.
  Future<void> launchApp() async {
    await tester.pumpWidget(const MyAppForTesting());
    await tester.pumpAndSettle(); // Wait until animations/UI are ready
  }

  /// Prepares Bloc after MyStringScreen is shown.
  ///
  /// Waits until [MyStringScreenBody] appears, then extracts the `MyStringBloc`.
  /// This ensures the app is fully navigated before accessing state.
  Future<void> prepareBloc() async {
    const timeout = Duration(seconds: 5);
    const pollInterval = Duration(milliseconds: 100);
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      await tester.pump(pollInterval); // Retry loop

      final myStringBodyFinder = find.byType(MyStringScreenBody);
      if (myStringBodyFinder.evaluate().isNotEmpty) {
        final myStringScreenState =
        tester.firstState<MyStringScreenBodyState>(myStringBodyFinder);
        bloc = myStringScreenState.exposedBloc;
        return;
      }
    }

    fail('❌ MyStringScreenBody not found within ${timeout.inSeconds} seconds.');
  }

  /// Re-extracts Bloc after app is relaunched (used in post-restart check).
  ///
  /// Same logic as [prepareBloc], but for when the app is launched a second time.
  Future<void> refreshAfterRestart() async {
    const timeout = Duration(seconds: 5);
    const pollInterval = Duration(milliseconds: 100);
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      await tester.pump(pollInterval);

      final myStringBodyFinder = find.byType(MyStringScreenBody);
      if (myStringBodyFinder.evaluate().isNotEmpty) {
        final myStringScreenState =
        tester.firstState<MyStringScreenBodyState>(myStringBodyFinder);
        bloc = myStringScreenState.exposedBloc;
        return;
      }
    }

    fail('❌ MyStringScreenBody not found within ${timeout.inSeconds} seconds.');
  }
}

/// A minimal version of the app for testing purposes.
///
/// It uses a top-level [BlocProvider] for [AuthBloc] so that [HomeScreen]
/// functions correctly in isolation.
class MyAppForTesting extends StatelessWidget {
  const MyAppForTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(),
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
