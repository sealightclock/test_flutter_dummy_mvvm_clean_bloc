import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper function to wait until a widget with a specific text appears.
///
/// Why needed?
/// - In integration tests, UI updates can be slightly delayed,
///   especially on real devices or after orientation/layout changes.
/// - This function helps avoid using random sleep durations (bad practice).
///
/// It keeps pumping the widget tree until the desired text appears
/// or until a timeout occurs (default 10 seconds).
Future<void> pumpUntilFound(WidgetTester tester,
    String text, {
      Duration timeout = const Duration(seconds: 10),
    }) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 200)); // Pump the widget tree

    if (find
        .text(text)
        .evaluate()
        .isNotEmpty) {
      return; // Text found, return success
    }
  }

  // If text is not found after timeout
  throw Exception('Timeout: Text "$text" not found within ${timeout.inSeconds} seconds');
}

/// Helper function to wait until a Bloc emits a specific state.
///
/// [matcher] is a function that returns true if the state is the one we want.
/// [timeout] is how long to wait before failing the test.
Future<void> waitForBlocState<B extends BlocBase<S>, S>(WidgetTester tester,
    B bloc,
    bool Function(S) matcher, {
      Duration timeout = const Duration(seconds: 10),
    }) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 200));

    if (matcher(bloc.state)) {
      return; // State matched!
    }
  }

  throw Exception('Timeout: Expected Bloc state not found within ${timeout.inSeconds} seconds.');
}

/// Pumps the widget tree until a specific widget is found, or timeout.
Future<void> pumpUntilFoundWidget(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 10)}) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder
        .evaluate()
        .isNotEmpty) {
      return;
    }
  }

  throw Exception('Timeout: Widget not found: $finder');
}

/// Waits until a widget of given type appears in the widget tree.
///
/// [T] is the widget type to wait for, e.g., MyStringScreen.
/// [timeoutSeconds] is the maximum time to wait before giving up.
///
/// Throws an exception if the widget is not found within timeout.
Future<void> waitForWidgetReady<T extends Widget>(WidgetTester tester, {
  int timeoutSeconds = 10,
}) async {
  final finder = find.byType(T);
  final endTime = DateTime.now().add(Duration(seconds: timeoutSeconds));

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder
        .evaluate()
        .isNotEmpty) {
      return; // Found the widget
    }
  }
  throw Exception('Timeout: Widget of type $T not found within $timeoutSeconds seconds.');
}

/// Waits for a Bloc to emit a state matching a condition
/// AND also for the UI to display a specific text.
///
/// This is safer than just waiting a fixed time.
///
/// - [tester] is the WidgetTester.
/// - [bloc] is the Bloc we are monitoring.
/// - [statePredicate] defines what Bloc state we are waiting for.
/// - [expectedText] defines what UI text we expect to appear.
Future<void> waitForBlocStateAndUi<B extends BlocBase<S>, S>(WidgetTester tester,
    B bloc,
    bool Function(S state) statePredicate,
    String expectedText,) async {
  const maxTries = 50; // 50 * 200ms = 10 seconds
  int tries = 0;

  bool success = false;

  await tester.pump(); // Initial frame

  // Repeatedly check both Bloc and UI
  while (tries < maxTries) {
    final currentState = bloc.state;
    final hasCorrectState = statePredicate(currentState);
    final hasExpectedText = find
        .text(expectedText)
        .evaluate()
        .isNotEmpty;

    if (hasCorrectState && hasExpectedText) {
      success = true;
      break;
    }

    await tester.pump(const Duration(milliseconds: 200));
    tries++;
  }

  if (!success) {
    throw Exception(
      'Timeout: Bloc did not reach desired state and UI did not display "$expectedText" within 10 seconds.',
    );
  }
}
