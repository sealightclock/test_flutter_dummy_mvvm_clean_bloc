import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Expect at least one Text widget contains the given string.
/// Useful when multiple widgets might show similar texts (e.g. TextField + Text).
Future<void> expectAnyTextWidgetWithText(WidgetTester tester, String expectedText) async {
  final allTextWidgets = find.byType(Text);

  expect(
    allTextWidgets.evaluate().any((e) {
      final textWidget = e.widget as Text;
      return textWidget.data == expectedText;
    }),
    true,
    reason: 'Expected at least one Text widget with text: "$expectedText"',
  );
}
