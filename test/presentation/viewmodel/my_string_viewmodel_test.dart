import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/get_my_string_from_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/store_my_string_to_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart'; // <-- Important!

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
      getFromLocalUseCase: mockGetLocal,
      storeToLocalUseCase: mockStoreLocal,
      getFromRemoteUseCase: mockGetRemote,
    );
  });

  test('getMyStringFromLocal returns expected string', () async {
    when(() => mockGetLocal.execute())
        .thenAnswer((_) async => Success(MyStringEntity(value: 'Local String')));

    final result = await viewModel.getMyStringFromLocal();

    switch (result) {
      case Success<MyStringEntity>(:final data):
        expect(data.value, 'Local String');
        break;
      case Failure<MyStringEntity>(:final message):
        fail('Expected Success but got Failure: $message');
    }
  });

  test('storeMyStringToLocal executes use case correctly', () async {
    when(() => mockStoreLocal.execute(any()))
        .thenAnswer((_) async => const Success(null)); // <- important

    await viewModel.storeMyStringToLocal('Save Me');

    verify(() => mockStoreLocal.execute(
        any(that: predicate<MyStringEntity>((entity) => entity.value == 'Save Me'))
    )).called(1);
  });

  test('getMyStringFromRemote returns expected string', () async {
    when(() => mockGetRemote.execute())
        .thenAnswer((_) async => Success(MyStringEntity(value: 'Remote String')));

    final result = await viewModel.getMyStringFromRemote();

    switch (result) {
      case Success<MyStringEntity>(:final data):
        expect(data.value, 'Remote String');
        break;
      case Failure<MyStringEntity>(:final message):
        fail('Expected Success but got Failure: $message');
    }
  });
}
