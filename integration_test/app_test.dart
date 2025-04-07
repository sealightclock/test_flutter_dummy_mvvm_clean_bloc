import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/app.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/main.dart' as app;
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/view/my_string_home_screen.dart';

import 'util/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App lifecycle with Hive persistence test', (tester) async {
    // Step 1: Launch the app
    await app.startApp(const MyApp());
    await tester.pumpAndSettle();

    // Step 2: Find HomeScreen and its Bloc
    final homeScreenFinder = find.byType(MyStringHomeScreen);
    expect(homeScreenFinder, findsOneWidget);

    final state = tester.state<MyStringHomeScreenState>(homeScreenFinder);
    final bloc = state.exposedBloc;

    // Step 3: Enter text and submit
    const testValue = 'Persistent String';
    await tester.enterText(find.byType(TextField), testValue);
    await tester.pumpAndSettle();

    final userButton = find.byKey(const Key('updateFromUserButton'));
    expect(userButton, findsOneWidget);

    await tester.tap(userButton);
    await tester.pumpAndSettle();

    // Step 4: Wait until Bloc emits success with correct value
    await waitForBlocState<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
    );

    // Step 5: Restart app
    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    // Step 6: Wait again for Bloc to emit correct value after restart
    await waitForBlocState<MyStringBloc, MyStringState>(
      tester,
      bloc,
          (state) => state is MyStringSuccessState && state.value == testValue,
    );
  });
}
