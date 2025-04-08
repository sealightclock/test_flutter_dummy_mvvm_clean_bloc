import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/view/my_string_home_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/viewmodel/my_string_viewmodel.dart';

import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart'; // <-- Important!

class MockMyStringViewModel extends Mock implements MyStringViewModel {}

void main() {
  testWidgets('updates UI when user submits a string', (WidgetTester tester) async {
    // Step 1: Set up mock ViewModel
    final mockViewModel = MockMyStringViewModel();

    when(() => mockViewModel.getMyStringFromLocal())
        .thenAnswer((_) async => Success(MyStringEntity(value: '')));
    when(() => mockViewModel.storeMyStringToLocal(any()))
        .thenAnswer((_) async => const Success(null));
    when(() => mockViewModel.getMyStringFromRemote())
        .thenAnswer((_) async => Success(MyStringEntity(value: 'From Server')));

    // Step 2: Pump the widget with the mock ViewModel injected
    await tester.pumpWidget(
      MaterialApp(
        home: MyStringHomeScreen(injectedViewModel: mockViewModel),
      ),
    );

    await tester.pumpAndSettle(); // Wait for async calls

    // Step 3: Simulate user input and tap
    const testInput = 'Hello Widget Test!';
    await tester.enterText(find.byType(TextField), testInput);

    final buttonFinder = find.byKey(const Key('updateFromUserButton'));
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Step 4: Assert the UI updated
    expect(find.text('Current Value:'), findsOneWidget);
    expect(find.text(testInput), findsOneWidget);
  });
}
