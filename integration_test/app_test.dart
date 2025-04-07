import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/main.dart' as app;

/// Helper function to wait until a widget with given text is found.
Future<void> pumpUntilFound(WidgetTester tester, String text, {Duration timeout = const Duration(seconds: 10)}) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 200)); // Small pump to allow UI to rebuild
    if (find.text(text).evaluate().isNotEmpty) {
      return; // Text found, return
    }
  }
  throw Exception('Timeout: Text "$text" not found within ${timeout.inSeconds} seconds');
}

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

    // Step 4: Restart the app (simulate lifecycle restart)
    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    // Step 5: Confirm the persisted value is still shown after restart
    await pumpUntilFound(tester, 'Current Value:');
    await pumpUntilFound(tester, testValue);
  });
}
