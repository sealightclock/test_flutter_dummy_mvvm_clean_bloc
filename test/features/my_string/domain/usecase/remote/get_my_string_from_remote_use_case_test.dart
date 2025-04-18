import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/data/repository/my_string_repository.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result_handler.dart';

class MockMyStringRepository extends Mock implements MyStringRepository {}

void main() {
  late GetMyStringFromRemoteUseCase useCase;
  late MockMyStringRepository mockRepo;

  setUp(() {
    mockRepo = MockMyStringRepository();
    useCase = GetMyStringFromRemoteUseCase(repository: mockRepo);
  });

  test('should return MyStringEntity from remote source', () async {
    final mockEntity = MyStringEntity(value: 'Remote Data');

    // Arrange: Mock the repository to return the mock entity
    when(() => mockRepo.getMyStringFromRemote())
        .thenAnswer((_) async => mockEntity);

    // Assert: Use handleResult to verify behavior
    await handleResult<MyStringEntity>(
      futureResult: useCase.execute(),
      onSuccess: (data) {
        expect(data.value, 'Remote Data');
        expect(data, isA<MyStringEntity>());
      },
      onFailure: (message) {
        fail('Expected success but got failure: $message');
      },
    );
  });
}
