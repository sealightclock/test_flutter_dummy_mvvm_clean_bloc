import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/view/auth_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';

import 'test_auth_viewmodel.dart';
import 'test_utils.dart';

/// Utility class to launch and prepare the app during integration tests.
class TestAppLauncher {
  final WidgetTester tester;
  late MyStringBloc bloc;

  TestAppLauncher(this.tester);

  /// Launches the app and waits for the initial widget to be ready
  Future<void> launchApp() async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthScreen(
          injectedViewModel: TestAuthViewModel(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 🛠️ Wait for AuthScreen or MyStringScreen
    await tester.pumpUntilFound(
      find.byType(Scaffold),
      timeout: const Duration(seconds: 15),
    );

    // ✅ Auto-login via guest if needed
    final moreOptionsButton = find.text('More Options');
    if (moreOptionsButton.evaluate().isNotEmpty) {
      await tester.tap(moreOptionsButton);
      await tester.pumpAndSettle();

      final guestLoginButton = find.text('Guest Login');
      if (guestLoginButton.evaluate().isNotEmpty) {
        await tester.tap(guestLoginButton);
        await tester.pumpAndSettle();
      }
    }

    // ✅ Wait until MyStringScreen is visible
    await tester.pumpUntilFound(
      find.byType(TextField),
      timeout: const Duration(seconds: 10),
    );
  }

  /// Prepare the bloc after reaching MyString screen
  Future<void> prepareBloc() async {
    bloc = Provider.of<MyStringBloc>(tester.element(find.byType(TextField)), listen: false);
  }

  /// Refresh bloc after app restart
  Future<void> refreshAfterRestart() async {
    await prepareBloc();
  }
}
