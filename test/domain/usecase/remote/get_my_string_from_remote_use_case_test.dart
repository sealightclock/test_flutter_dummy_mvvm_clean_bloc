import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/data/repository/my_string_repository.dart';

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
    expect(result.value, 'Remote Data');
    expect(result, isA<MyStringEntity>());
  });
}
