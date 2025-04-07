import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';

import 'util/test_app_launcher.dart';   // Helper for launching and reloading app
import 'util/test_timer.dart';           // Timer for measuring test duration
import 'util/test_utils.dart';          // Helper functions like waitForBlocState, waitForWidgetReady

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App lifecycle with Hive persistence test', (tester) async {
    // ⏱️ Start timer for measuring test duration
    final timer = TestTimer('App lifecycle with Hive persistence test');
    timer.start();

    // 🚀 Step 1: Launch app and get initial bloc
    final launcher = TestAppLauncher(tester);
    await launcher.launchApp();
    final bloc = launcher.bloc;

    // 📝 Step 2: Enter text and submit
    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);

    await tester.tap(userButton);
    await tester.pumpAndSettle();

    // ✅ Step 3: Wait until Bloc emits the success state
    await waitForBlocState<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
    );

    // Step 4: Restart app
    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    // Step 4.5: Refresh HomeScreen and Bloc!
    await launcher.refreshAfterRestart();

    // Step 5: Wait again after restart
    await waitForBlocState<MyStringBloc, MyStringState>(
      tester,
      launcher.bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
    );

    // 🔄 Step 6: Refresh TestAppLauncher to get new Bloc after restart
    await launcher.refreshAfterRestart();
    final newBloc = launcher.bloc;

    // ✅ Step 7: Confirm the persisted value is still shown after restart
    await waitForBlocState<MyStringBloc, MyStringState>(
      tester,
      newBloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
    );

    // 🛑 Step 8: Stop timer and report test duration
    timer.stop();
  });
}
