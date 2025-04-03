import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/presentation/viewmodel/my_string_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/get_my_string_from_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/store_my_string_to_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';

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
      getLocalUseCase: mockGetLocal,
      storeLocalUseCase: mockStoreLocal,
      getRemoteUseCase: mockGetRemote,
    );
  });

  test('getMyStringFromLocal returns expected string', () async {
    when(() => mockGetLocal.execute())
        .thenAnswer((_) async => MyStringEntity(value: 'Local String'));

    final result = await viewModel.getMyStringFromLocal();

    expect(result, 'Local String');
  });

  test('storeMyStringToLocal executes use case correctly', () async {
    when(() => mockStoreLocal.execute(any())).thenAnswer((_) async {});

    await viewModel.storeMyStringToLocal('Save Me');

    verify(() => mockStoreLocal.execute(
        any(that: predicate<MyStringEntity>((entity) => entity.value == 'Save Me'))
    )).called(1);
  });

  test('getMyStringFromRemote returns expected string', () async {
    when(() => mockGetRemote.execute())
        .thenAnswer((_) async => MyStringEntity(value: 'Remote String'));

    final result = await viewModel.getMyStringFromRemote();

    expect(result, 'Remote String');
  });
}
