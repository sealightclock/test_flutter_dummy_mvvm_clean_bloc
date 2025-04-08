import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/view/my_string_screen.dart';

import 'test_utils.dart'; // Make sure waitForWidgetReady() is here

class TestAppLauncher {
  final WidgetTester tester;

  TestAppLauncher(this.tester);

  // The MyStringBloc instance for direct access in the test
  late MyStringBloc bloc;

  /// Launch the app, but don't assume MyStringHomeScreen immediately.
  Future<void> launchApp() async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    // No waiting for MyStringHomeScreen yet
    // Test code will control navigation to MyString screen
  }

  /// Call this manually **AFTER** you have navigated to MyStringHomeScreen
  Future<void> prepareBloc() async {
    await waitForWidgetReady<MyStringScreen>(tester);

    final homeScreenFinder = find.byType(MyStringScreen);
    final state = tester.state<MyStringScreenState>(homeScreenFinder);

    bloc = state.bloc;
  }

  /// Refresh the bloc after app restart (same as before)
  Future<void> refreshAfterRestart() async {
    await waitForWidgetReady<MyStringScreen>(tester);

    final homeScreenFinder = find.byType(MyStringScreen);
    final state = tester.state<MyStringScreenState>(homeScreenFinder);

    bloc = state.bloc;
  }
}
