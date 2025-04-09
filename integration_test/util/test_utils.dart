import 'package:flutter_test/flutter_test.dart';

/// Waits for a specific Bloc state and UI value
Future<void> waitForBlocStateAndUi<B, S>(
    WidgetTester tester,
    B bloc,
    bool Function(S state) condition,
    String expectedText, {
      Duration timeout = const Duration(seconds: 10),
      Duration step = const Duration(milliseconds: 100),
    }) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(step);

    final currentState = (bloc as dynamic).state as S;
    if (condition(currentState)) {
      // Also check UI reflects the correct value
      expect(find.text(expectedText), findsOneWidget);
      return;
    }
  }
  throw TestFailure('Timeout waiting for bloc state and UI text: "$expectedText"');
}

/// Extension method for WidgetTester to pump until a specific widget is found
extension PumpUntilFoundExtension on WidgetTester {
  Future<void> pumpUntilFound(
      Finder finder, {
        Duration timeout = const Duration(seconds: 10),
        Duration step = const Duration(milliseconds: 100),
      }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await pump(step);
      if (any(finder)) return;
    }
    throw TestFailure('pumpUntilFound timeout: ${finder.description}');
  }
}
