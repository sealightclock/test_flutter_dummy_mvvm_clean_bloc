import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/view/my_string_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/viewmodel/my_string_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart';

// --- Fake classes ---
class FakeMyStringBloc extends MockBloc<MyStringEvent, MyStringState> implements MyStringBloc {}

class FakeMyStringViewModel extends Fake implements MyStringViewModel {
  @override
  Future<Result<MyStringEntity>> getMyStringFromLocal() async {
    return Success(MyStringEntity(value: 'Hello World'));
  }
}

void main() {
  late FakeMyStringBloc fakeBloc;
  late FakeMyStringViewModel fakeViewModel;

  setUp(() {
    fakeBloc = FakeMyStringBloc();
    fakeViewModel = FakeMyStringViewModel();
    when(() => fakeBloc.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    fakeBloc.close();
  });

  group('MyStringScreen Widget Tests', () {
    testWidgets('displays final Success UI correctly after loading', (WidgetTester tester) async {
      // Arrange
      when(() => fakeBloc.state).thenReturn(MyStringInitialState());
      whenListen(
        fakeBloc,
        Stream<MyStringState>.fromIterable([
          MyStringInitialState(),
          MyStringSuccessState('Hello World'),
        ]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MyStringBloc>.value(
            value: fakeBloc,
            child: MyStringScreen(
              injectedViewModel: fakeViewModel,
              injectedBloc: fakeBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(); // Wait all rebuilds

      // Assert
      expect(find.text('Current Value:'), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('shows loading spinner when loading', (WidgetTester tester) async {
      // Arrange
      when(() => fakeBloc.state).thenReturn(MyStringLoadingState());
      whenListen(
        fakeBloc,
        Stream<MyStringState>.fromIterable([
          MyStringLoadingState(),
        ]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MyStringBloc>.value(
            value: fakeBloc,
            child: MyStringScreen(
              injectedViewModel: fakeViewModel,
              injectedBloc: fakeBloc,
            ),
          ),
        ),
      );
      await tester.pump(); // Only pump a frame, don't wait

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays fetched string when success', (WidgetTester tester) async {
      // Arrange
      when(() => fakeBloc.state).thenReturn(MyStringSuccessState('Hello World'));
      whenListen(
        fakeBloc,
        Stream<MyStringState>.fromIterable([
          MyStringSuccessState('Hello World'),
        ]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MyStringBloc>.value(
            value: fakeBloc,
            child: MyStringScreen(
              injectedViewModel: fakeViewModel,
              injectedBloc: fakeBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Current Value:'), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('shows error message when error state', (WidgetTester tester) async {
      // Arrange
      when(() => fakeBloc.state).thenReturn(MyStringErrorState('Something went wrong'));
      whenListen(
        fakeBloc,
        Stream<MyStringState>.fromIterable([
          MyStringErrorState('Something went wrong'),
        ]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MyStringBloc>.value(
            value: fakeBloc,
            child: MyStringScreen(
              injectedViewModel: fakeViewModel,
              injectedBloc: fakeBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Error: Something went wrong'), findsOneWidget);
    });
  });
}
