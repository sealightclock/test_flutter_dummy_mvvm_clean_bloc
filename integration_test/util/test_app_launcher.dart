import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/main.dart' as app;
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';

/// A small helper class to launch the app and expose useful testing elements.
class TestAppLauncher {
  final WidgetTester tester;
  late final MyStringBloc bloc;

  TestAppLauncher(this.tester);

  /// Launches the app, waits for UI settle, and finds necessary widgets.
  Future<void> launchApp() async {
    // Start the app
    await app.startApp(const MyApp());
    await tester.pumpAndSettle();

    // Find the HomeScreen
    final homeScreenFinder = find.byType(MyStringHomeScreen);
    expect(homeScreenFinder, findsOneWidget);

    // Access the bloc via the exposed getter
    final state = tester.state<MyStringHomeScreenState>(homeScreenFinder);
    bloc = state.exposedBloc;
  }
}
