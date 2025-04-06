import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/data/repository/my_string_repository.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart'; // <-- Important!

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
    when(() => mockRepo.getMyStringFromRemote())
        .thenAnswer((_) async => mockEntity);

    final result = await useCase.execute();

    // We need to check that the Result is a Success and contains correct data.
    switch (result) {
      case Success<MyStringEntity>(:final data):
        expect(data.value, 'Remote Data');
        expect(data, isA<MyStringEntity>());
        break;
      case Failure<MyStringEntity>(:final message):
        fail('Expected success but got failure: $message');
    }
  });
}
