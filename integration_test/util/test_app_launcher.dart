import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/main.dart' as app;
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';

import 'test_utils.dart'; // <-- for pumpUntilFound

/// A small helper class to launch the app and expose useful testing elements.
class TestAppLauncher {
  final WidgetTester tester;
  late final MyStringBloc bloc;

  TestAppLauncher(this.tester);

  /// Launches the app, waits for HomeScreen ready, and finds necessary widgets.
  Future<void> launchApp() async {
    await app.startApp(const MyApp());

    // Instead of full settle, do a quick pump
    await tester.pump(const Duration(milliseconds: 500));

    // Then wait until HomeScreen is found
    await pumpUntilFoundWidget(tester, find.byType(MyStringHomeScreen));

    // Find the HomeScreen
    final homeScreenFinder = find.byType(MyStringHomeScreen);
    expect(homeScreenFinder, findsOneWidget);

    // Access the bloc via the exposed getter
    final state = tester.state<MyStringHomeScreenState>(homeScreenFinder);
    bloc = state.exposedBloc;
  }
}
