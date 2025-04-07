import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper function to wait until a widget with a specific text appears.
///
/// Why needed?
/// - In integration tests, UI updates can be slightly delayed,
///   especially on real devices or after orientation/layout changes.
/// - This function helps avoid using random sleep durations (bad practice).
///
/// It keeps pumping the widget tree until the desired text appears
/// or until a timeout occurs (default 10 seconds).
Future<void> pumpUntilFound(
    WidgetTester tester,
    String text, {
      Duration timeout = const Duration(seconds: 10),
    }) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 200)); // Pump the widget tree

    if (find.text(text).evaluate().isNotEmpty) {
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
Future<void> waitForBlocState<B extends BlocBase<S>, S>(
    WidgetTester tester,
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
