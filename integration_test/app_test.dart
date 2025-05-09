import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_state.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/root_screen.dart'; // ✅ Needed for forceStartOnMyStringScreen

import 'util/reset_hive.dart';
import 'util/test_app_launcher.dart';
import 'util/test_timer.dart';
import 'util/test_utils.dart';

void main() {
  // Bind integration test environment (required boilerplate)
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app lifecycle with Auth and MyString persistence', (tester) async {
    // ─────────────────────────────────────────────────────────────────────
    // 👟 Step 0a: Temporary splash screen during test setup
    // ─────────────────────────────────────────────────────────────────────
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('🧹 Resetting Hive...')),
      ),
    ));
    await tester.pumpAndSettle();

    // This ensures that the integration test still works even if an old app
    // was installed on the device with old Hive data.
    await resetHive();

    // ─────────────────────────────────────────────────────────────────────
    // ⏱️ Step 1: Start timer for debugging test duration
    // ─────────────────────────────────────────────────────────────────────
    final timer = TestTimer('Full app lifecycle with Auth and MyString persistence');
    timer.start();

    // ─────────────────────────────────────────────────────────────────────
    // 🚀 Step 2: Launch the app
    // ❗ Force app to start on MyStringScreen (ignore last seen screen)
    // ─────────────────────────────────────────────────────────────────────
    forceStartOnMyStringScreen = true; // ✅ Ensures test always starts on desired screen
    final launcher = TestAppLauncher(tester);
    await launcher.launchApp();

    // ─────────────────────────────────────────────────────────────────────
    // 🧑 Step 3: Simulate guest login if Auth screen is shown
    // ─────────────────────────────────────────────────────────────────────
    final moreOptionsFinder = find.text('More Options');
    if (moreOptionsFinder.evaluate().isNotEmpty) {
      await tester.tap(moreOptionsFinder);
      await tester.pumpAndSettle();

      final guestLoginButton = find.text('Guest Login');
      expect(guestLoginButton, findsOneWidget);
      await tester.tap(guestLoginButton);
      await tester.pumpAndSettle();
    }

    // ─────────────────────────────────────────────────────────────────────
    // 🎯 Step 4: Prepare Bloc on MyString screen
    // ─────────────────────────────────────────────────────────────────────
    await launcher.prepareBloc();
    final bloc = launcher.bloc;

    // ─────────────────────────────────────────────────────────────────────
    // ⌨️ Step 5: Enter test string and tap "Update from User"
    // ─────────────────────────────────────────────────────────────────────
    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);
    await tester.tap(userButton);
    await tester.pumpAndSettle();

    // ─────────────────────────────────────────────────────────────────────
    // ✅ Step 6: Confirm both Bloc state + UI show the entered value
    // ─────────────────────────────────────────────────────────────────────
    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    // ─────────────────────────────────────────────────────────────────────
    // 🔁 Step 7: Relaunch app to simulate real user relaunch
    // ─────────────────────────────────────────────────────────────────────
    await launcher.launchApp();
    await tester.pumpAndSettle();

    // ─────────────────────────────────────────────────────────────────────
    // 🧑 Step 8: Handle guest login again if Auth screen reappears
    // ─────────────────────────────────────────────────────────────────────
    final moreOptionsFinderAfterRelaunch = find.text('More Options');
    if (moreOptionsFinderAfterRelaunch.evaluate().isNotEmpty) {
      await tester.tap(moreOptionsFinderAfterRelaunch);
      await tester.pumpAndSettle();

      final guestLoginButtonAfterRelaunch = find.text('Guest Login');
      expect(guestLoginButtonAfterRelaunch, findsOneWidget);
      await tester.tap(guestLoginButtonAfterRelaunch);
      await tester.pumpAndSettle();
    }

    // ─────────────────────────────────────────────────────────────────────
    // 🎯 Step 9: Refresh Bloc after app relaunch
    // ─────────────────────────────────────────────────────────────────────
    await launcher.refreshAfterRestart();
    final blocAfterRelaunch = launcher.bloc;

    // ─────────────────────────────────────────────────────────────────────
    // ✅ Step 10: Confirm string still persists after relaunch
    // ─────────────────────────────────────────────────────────────────────
    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      blocAfterRelaunch,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    // ─────────────────────────────────────────────────────────────────────
    // 🏁 Step 11: Stop timer and end test
    // ─────────────────────────────────────────────────────────────────────
    timer.stop();
  });
}
