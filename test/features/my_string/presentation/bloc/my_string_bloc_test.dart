import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_event.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/bloc/my_string_state.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/model/my_string_model.dart';

void main() {
  group('MyStringBloc', () {
    blocTest<MyStringBloc, MyStringState>(
      'emits [Loading, Loaded] when UpdateMyStringFromServerEvent succeeds',
      build: () => MyStringBloc(),
      act: (bloc) => bloc.add(MyStringUpdateFromServerEvent(() async => MyStringModel(value: 'Server Value'))),
      expect: () =>
      [
        isA<MyStringLoadingState>(),
        isA<MyStringSuccessState>().having((s) => s.value.value, 'value', 'Server Value'),
      ],
    );

    blocTest<MyStringBloc, MyStringState>(
      'emits [Loading, Error] when UpdateMyStringFromServerEvent throws',
      build: () => MyStringBloc(),
      act: (bloc) =>
          bloc.add(MyStringUpdateFromServerEvent(() async {
            throw Exception('Server down');
          })),
      expect: () =>
      [
        isA<MyStringLoadingState>(),
        isA<MyStringErrorState>().having((s) => s.message, 'message', contains('Server down')),
      ],
    );

    blocTest<MyStringBloc, MyStringState>(
      'emits [Loaded] when UpdateMyStringFromUserEvent is added',
      build: () => MyStringBloc(),
      act: (bloc) => bloc.add(MyStringUpdateFromUserEvent(MyStringModel(value: 'User Input'))),
      expect: () =>
      [
        isA<MyStringSuccessState>().having((s) => s.value.value, 'value', 'User Input'),
      ],
    );

    blocTest<MyStringBloc, MyStringState>(
      'emits [Loaded] when UpdateMyStringFromLocalEvent is added',
      build: () => MyStringBloc(),
      act: (bloc) => bloc.add(MyStringUpdateFromLocalEvent(MyStringModel(value: 'Local Value'))),
      expect: () =>
      [
        isA<MyStringSuccessState>().having((s) => s.value.value, 'value', 'Local Value'),
      ],
    );
  });
}
