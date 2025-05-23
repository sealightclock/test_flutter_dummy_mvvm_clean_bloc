import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/core/result/result.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/core/result/result_handler.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/usecase/get_my_string_from_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/usecase/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/usecase/store_my_string_to_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/model/my_string_model.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/viewmodel/my_string_viewmodel.dart';

class MockGetLocal extends Mock implements GetMyStringFromLocalUseCase {}

class MockStoreLocal extends Mock implements StoreMyStringToLocalUseCase {}

class MockGetRemote extends Mock implements GetMyStringFromRemoteUseCase {}

void main() {
  late MyStringViewModel viewModel;
  late MockGetLocal mockGetLocal;
  late MockStoreLocal mockStoreLocal;
  late MockGetRemote mockGetRemote;

  setUpAll(() {
    registerFallbackValue(MyStringEntity(value: 'fallback'));
  });

  setUp(() {
    mockGetLocal = MockGetLocal();
    mockStoreLocal = MockStoreLocal();
    mockGetRemote = MockGetRemote();

    viewModel = MyStringViewModel(
      getMyStringFromLocalUseCase: mockGetLocal,
      storeMyStringToLocalUseCase: mockStoreLocal,
      getMyStringFromRemoteUseCase: mockGetRemote,
    );
  });

  test('getMyStringFromLocal returns expected string', () async {
    when(() => mockGetLocal.call())
        .thenAnswer((_) async => Success(MyStringEntity(value: 'Local String')));

    final result = await viewModel.getMyStringFromLocal();

    switch (result) {
      case Success<MyStringModel>(:final data):
        expect(data.value, 'Local String');
        break;
      case Failure<MyStringModel>(:final message):
        fail('Expected Success but got Failure: $message');
    }
  });

  test('storeMyStringToLocal executes use case correctly', () async {
    when(() => mockStoreLocal.call(any()))
        .thenAnswer((_) async => const Success(null)); // <- important

    await viewModel.storeMyStringToLocal(MyStringModel(value: 'Save Me'));

    verify(() =>
        mockStoreLocal.call(
            any(that: predicate<MyStringEntity>((entity) => entity.value == 'Save Me'))
        )).called(1);
  });

  test('getMyStringFromRemote returns expected string', () async {
    when(() => mockGetRemote.call())
        .thenAnswer((_) async => Success(MyStringEntity(value: 'Remote String')));

    handleResult<MyStringModel>(
      futureResult: viewModel.getMyStringFromRemote(),
      onSuccess: (data) {
        expect(data.value, 'Remote String');
        expect(data, isA<MyStringModel>());
      },
      onFailure: (message) {
        fail('Expected success but got failure: $message');
      },
    );
  });
}
