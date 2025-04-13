// Updated file: integration_test/util/test_app_launcher.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart'; // ✅ Need this for providing AuthBloc
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/view/my_string_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/home_screen.dart';

/// Utility class to help launching the app during integration tests.
class TestAppLauncher {
  final WidgetTester tester;

  late MyStringBloc bloc; // MyStringBloc instance

  TestAppLauncher(this.tester);

  /// Launch the app for testing.
  Future<void> launchApp() async {
    // Start the app wrapped with a Provider for AuthBloc
    await tester.pumpWidget(const MyAppForTesting());
    await tester.pumpAndSettle();
  }

  /// Prepare Bloc after navigating to MyStringScreen.
  Future<void> prepareBloc() async {
    // Now find MyStringScreenBody instead of MyStringScreen!
    final myStringBodyFinder = find.byType(MyStringScreenBody);
    expect(myStringBodyFinder, findsOneWidget);

    final myStringScreenState = tester.firstState<MyStringScreenBodyState>(myStringBodyFinder);

    bloc = myStringScreenState.exposedBloc;
  }

  /// After app relaunch, refresh Bloc reference.
  Future<void> refreshAfterRestart() async {
    final myStringBodyFinder = find.byType(MyStringScreenBody);
    expect(myStringBodyFinder, findsOneWidget);

    final myStringScreenState = tester.firstState<MyStringScreenBodyState>(myStringBodyFinder);

    bloc = myStringScreenState.exposedBloc;
  }
}

/// Dummy app for testing.
/// - Wrapped with `BlocProvider<AuthBloc>` so that HomeScreen works properly.
class MyAppForTesting extends StatelessWidget {
  const MyAppForTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(), // Create AuthBloc needed for HomeScreen
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
