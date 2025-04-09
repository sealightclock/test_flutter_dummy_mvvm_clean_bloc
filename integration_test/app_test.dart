import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';

import 'util/test_utils.dart';
import 'util/test_app_launcher.dart';
import 'util/test_timer.dart';
import 'util/reset_hive.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app lifecycle with Auth and MyString persistence', (tester) async {
    await resetHive();

    final timer = TestTimer('Full app lifecycle with Auth and MyString persistence');
    timer.start();

    final launcher = TestAppLauncher(tester);
    await launcher.launchApp();

    final moreOptionsFinder = find.text('More Options');
    if (moreOptionsFinder.evaluate().isNotEmpty) {
      await tester.tap(moreOptionsFinder);
      await tester.pumpAndSettle();

      final guestLoginButton = find.text('Guest Login');
      expect(guestLoginButton, findsOneWidget);
      await tester.tap(guestLoginButton);
      await tester.pump(); // tap triggers bloc event

      // ⏳ Wait for navigation to MyStringScreen by checking
      await tester.pumpUntilFound(find.byType(TextField), timeout: const Duration(seconds: 10));
    }

    await launcher.prepareBloc();
    final bloc = launcher.bloc;

    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);
    await tester.tap(userButton);
    await tester.pumpAndSettle();

    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    await launcher.launchApp();
    await tester.pumpAndSettle();

    final moreOptionsFinderAfterRelaunch = find.text('More Options');
    if (moreOptionsFinderAfterRelaunch.evaluate().isNotEmpty) {
      await tester.tap(moreOptionsFinderAfterRelaunch);
      await tester.pumpAndSettle();

      final guestLoginButtonAfterRelaunch = find.text('Guest Login');
      expect(guestLoginButtonAfterRelaunch, findsOneWidget);
      await tester.tap(guestLoginButtonAfterRelaunch);
      await tester.pump();

      // ⏳ Again wait for navigation to MyStringScreen
      await tester.pumpUntilFound(find.byType(TextField), timeout: const Duration(seconds: 10));
    }

    await launcher.refreshAfterRestart();
    final blocAfterRelaunch = launcher.bloc;

    await waitForBlocStateAndUi<MyStringBloc, MyStringState>(
      tester,
      blocAfterRelaunch,
          (state) => state is MyStringSuccessState && state.value == testValue,
      testValue,
    );

    timer.stop();
  });
}
