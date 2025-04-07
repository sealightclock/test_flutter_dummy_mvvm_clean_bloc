import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';

import 'util/test_utils.dart';
import 'util/test_app_launcher.dart';
import 'util/test_timer.dart'; // <-- NEW!

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App lifecycle with Hive persistence test', (tester) async {
    // Start timer
    final timer = TestTimer('App lifecycle with Hive persistence test');
    timer.start();

    // Launch app
    final launcher = TestAppLauncher(tester);
    await launcher.launchApp();
    final bloc = launcher.bloc;

    // Step 2: Enter text and submit
    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);

    await tester.tap(userButton);
    await tester.pumpAndSettle();

    // Step 3: Wait until Bloc emits success
    await waitForBlocState<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
    );

    // Step 4: Restart app
    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    // Step 5: Wait again after restart
    await waitForBlocState<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
    );

    // Stop timer
    timer.stop();
  });
}
