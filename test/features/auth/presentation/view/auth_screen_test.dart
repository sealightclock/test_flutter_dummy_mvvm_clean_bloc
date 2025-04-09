import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/view/auth_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart';

import '../../../../util/fake_user_auth_entity_factory.dart'; // <-- New import

// -----------------------------
// Fake Bloc + Mock ViewModel
// -----------------------------
class FakeAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthViewModel extends Mock implements AuthViewModel {}

void main() {
  late FakeAuthBloc fakeAuthBloc;
  late FakeAuthViewModel fakeAuthViewModel;

  setUp(() {
    fakeAuthBloc = FakeAuthBloc();
    fakeAuthViewModel = FakeAuthViewModel();

    when(() => fakeAuthBloc.close()).thenAnswer((_) async {});

    when(() => fakeAuthViewModel.getUserAuthStatus())
        .thenAnswer((_) async => FakeUserAuthEntityFactory.guest());

    when(() => fakeAuthViewModel.login(any(), any()))
        .thenAnswer((_) async => Success<void>(null));

    when(() => fakeAuthViewModel.signUp(any(), any()))
        .thenAnswer((_) async => Success<void>(null));

    when(() => fakeAuthViewModel.guestLogin())
        .thenAnswer((_) async => Success<void>(null));
  });

  tearDown(() {
    fakeAuthBloc.close();
  });

  group('AuthScreen Widget Tests', () {
    testWidgets('displays login and signup buttons', (tester) async {
      // Arrange
      when(() => fakeAuthBloc.state).thenReturn(AuthInitialState());
      whenListen(
        fakeAuthBloc,
        Stream<AuthState>.fromIterable([
          AuthInitialState(),
        ]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: fakeAuthBloc,
            child: AuthScreen(
              injectedViewModel: fakeAuthViewModel,
              injectedBloc: fakeAuthBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('More Options'), findsOneWidget);
    });

    testWidgets('shows loading spinner when AuthLoadingState', (tester) async {
      // Arrange
      when(() => fakeAuthBloc.state).thenReturn(AuthLoadingState());
      whenListen(
        fakeAuthBloc,
        Stream<AuthState>.fromIterable([
          AuthLoadingState(),
        ]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: fakeAuthBloc,
            child: AuthScreen(
              injectedViewModel: fakeAuthViewModel,
              injectedBloc: fakeAuthBloc,
            ),
          ),
        ),
      );
      await tester.pump(); // Do NOT call pumpAndSettle() during spinner loading

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to MyStringScreen when authenticated', (tester) async {
      // Arrange
      final user = FakeUserAuthEntityFactory.loggedInUser();
      when(() => fakeAuthBloc.state)
          .thenReturn(AuthAuthenticatedState(user: user));
      whenListen(
        fakeAuthBloc,
        Stream<AuthState>.fromIterable([
          AuthAuthenticatedState(user: user),
        ]),
      );
      when(() => fakeAuthViewModel.getUserAuthStatus())
          .thenAnswer((_) async => user);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: fakeAuthBloc,
            child: AuthScreen(
              injectedViewModel: fakeAuthViewModel,
              injectedBloc: fakeAuthBloc,
            ),
          ),
        ),
      );
      await tester.pump(); // Allow navigation frame to happen

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error when AuthErrorState', (tester) async {
      // Arrange
      when(() => fakeAuthBloc.state)
          .thenReturn(AuthErrorState(message: 'Login failed'));
      whenListen(
        fakeAuthBloc,
        Stream<AuthState>.fromIterable([
          AuthErrorState(message: 'Login failed'),
        ]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: fakeAuthBloc,
            child: AuthScreen(
              injectedViewModel: fakeAuthViewModel,
              injectedBloc: fakeAuthBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Login failed'), findsOneWidget);
    });
  });
}
