import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/main.dart' as app;

import 'util/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App lifecycle with Hive persistence test', (tester) async {
    // Step 1: Launch the app
    await app.startApp(const MyApp());
    await tester.pumpAndSettle();

    // Step 2: Enter text and submit
    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);

    await tester.tap(userButton);
    await tester.pumpAndSettle();

    // Step 3: Confirm that the UI shows the new value
    await pumpUntilFound(tester, 'Current Value:');
    await pumpUntilFound(tester, testValue);

    // Step 4: ✨ Additional pump to wait for Hive saving to complete
    await tester.pump(const Duration(seconds: 2)); // <-- Important! Give Hive time to persist data

    // Step 5: Restart the app (simulate lifecycle restart)
    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    // Step 6: Confirm the persisted value is still shown after restart
    await pumpUntilFound(tester, 'Current Value:');
    await pumpUntilFound(tester, testValue);
  });
}
