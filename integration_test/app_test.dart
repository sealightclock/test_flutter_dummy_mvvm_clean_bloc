import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';

import 'util/test_utils.dart';
import 'util/test_app_launcher.dart';
import 'util/test_timer.dart'; // For measuring test time
import 'util/reset_hive.dart'; // Import resetHive

void main() {
  // Bind integration test environment
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app lifecycle with Auth and MyString persistence', (tester) async {
    // Step 0: Reset Hive for a fresh start
    await resetHive();

    // Step 1: Start timer
    final timer = TestTimer('Full app lifecycle with Auth and MyString persistence');
    timer.start();

    // Step 2: Launch the app
    final launcher = TestAppLauncher(tester);
    await launcher.launchApp();

    // Step 3: Handle Auth screen if needed
    final moreOptionsFinder = find.text('More Options');

    if (moreOptionsFinder.evaluate().isNotEmpty) {
      await tester.tap(moreOptionsFinder);
      await tester.pumpAndSettle();

      final guestLoginButton = find.text('Guest Login');
      expect(guestLoginButton, findsOneWidget);
      await tester.tap(guestLoginButton);
      await tester.pumpAndSettle();
    }

    // Step 4: Now prepare the bloc (after reaching MyString screen)
    await launcher.prepareBloc();
    final bloc = launcher.bloc;

    // Step 5: Enter text and submit
    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);

    await tester.tap(userButton);
    await tester.pumpAndSettle();

    // Step 6: Wait for Bloc + UI confirmation BEFORE app relaunch
    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    // Step 7: Relaunch the app manually (instead of restartAndRestore)
    await launcher.launchApp();
    await tester.pumpAndSettle();

    // Step 8: Handle Auth screen again if needed
    final moreOptionsFinderAfterRelaunch = find.text('More Options');

    if (moreOptionsFinderAfterRelaunch.evaluate().isNotEmpty) {
      await tester.tap(moreOptionsFinderAfterRelaunch);
      await tester.pumpAndSettle();

      final guestLoginButtonAfterRelaunch = find.text('Guest Login');
      expect(guestLoginButtonAfterRelaunch, findsOneWidget);
      await tester.tap(guestLoginButtonAfterRelaunch);
      await tester.pumpAndSettle();
    }

    // Step 9: Refresh the bloc after relaunch
    await launcher.refreshAfterRestart();
    final blocAfterRelaunch = launcher.bloc;

    // Step 10: Wait for Bloc + UI confirmation AFTER app relaunch
    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      blocAfterRelaunch,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    // Step 11: End timer
    timer.stop();
  });
}
