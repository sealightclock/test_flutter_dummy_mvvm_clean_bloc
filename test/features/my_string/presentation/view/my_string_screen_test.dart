import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/view/my_string_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';

void main() {
  testWidgets('updates UI when user submits a string', (WidgetTester tester) async {
    final bloc = MyStringBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MyStringScreen(injectedBloc: bloc),
      ),
    );

    await tester.pumpAndSettle();

    const testInput = 'Hello Widget Test!';
    await tester.enterText(find.byType(TextField), testInput);
    await tester.tap(find.byKey(const Key('updateFromUserButton')));

    await tester.pumpAndSettle();

    expect(find.text('Current Value:'), findsOneWidget);
    expect(find.text(testInput), findsOneWidget);
  });
}
