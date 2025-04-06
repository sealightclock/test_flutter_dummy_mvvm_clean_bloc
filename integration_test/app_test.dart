import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/main.dart' as app;

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
    expect(find.text('Current Value:'), findsOneWidget);
    expect(find.text(testValue), findsOneWidget);

    // Step 4: Wait a bit to ensure Hive fully saves before restart
    await Future.delayed(const Duration(milliseconds: 10000)); // <-- Important
    // on real devices!

    // Step 5: Restart the app (simulate lifecycle restart)
    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    // Step 6: Wait again for Hive read completion
    await tester.pump(const Duration(seconds: 10)); // Give Hive time to
    // initialize

    // Step 7: Confirm the persisted value is still shown
    expect(find.text('Current Value:'), findsOneWidget);
    expect(find.text(testValue), findsOneWidget);
  });
}
