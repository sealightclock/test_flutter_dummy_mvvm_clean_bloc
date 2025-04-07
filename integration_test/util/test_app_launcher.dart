import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';

import 'test_utils.dart'; // Make sure waitForWidgetReady() is here

class TestAppLauncher {
  final WidgetTester tester;

  TestAppLauncher(this.tester);

  // The MyStringBloc instance for direct access in the test
  late MyStringBloc bloc;

  /// Launch the app and wait for MyStringHomeScreen to appear.
  Future<void> launchApp() async {
    await tester.pumpWidget(const MyApp());

    // 💡 Wait until MyStringHomeScreen is ready!
    await waitForWidgetReady<MyStringHomeScreen>(tester);

    // Now it's guaranteed safe to find bloc
    final homeScreenFinder = find.byType(MyStringHomeScreen);
    final state = tester.state<MyStringHomeScreenState>(homeScreenFinder);

    bloc = state.bloc;
  }

  /// Refresh the bloc after app restart.
  Future<void> refreshAfterRestart() async {
    await waitForWidgetReady<MyStringHomeScreen>(tester);

    final homeScreenFinder = find.byType(MyStringHomeScreen);
    final state = tester.state<MyStringHomeScreenState>(homeScreenFinder);

    bloc = state.bloc;
  }
}
