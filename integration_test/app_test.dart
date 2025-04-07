import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';

import 'util/test_utils.dart';
import 'util/test_app_launcher.dart';
import 'util/test_timer.dart'; // For measuring test time

void main() {
  // Bind integration test environment
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App lifecycle with Hive persistence test', (tester) async {
    // Step 1: Start timer
    final timer = TestTimer('App lifecycle with Hive persistence test');
    timer.start();

    // Step 2: Launch the app
    final launcher = TestAppLauncher(tester);
    await launcher.launchApp();
    final bloc = launcher.bloc;

    // Step 3: Enter text and submit
    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);

    await tester.tap(userButton);
    await tester.pumpAndSettle();

    // Step 4: Wait for Bloc + UI confirmation BEFORE restart
    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    // Step 5: Restart the app (simulate app kill and restore)
    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    // Step 6: Wait for Bloc + UI confirmation AFTER restart
    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    // Step 7: End timer
    timer.stop();
  });
}
