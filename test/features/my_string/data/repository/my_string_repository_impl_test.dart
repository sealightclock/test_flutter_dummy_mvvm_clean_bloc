import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/data/local/my_string_local_data_source.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/data/remote/my_string_remote_data_source.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/data/repository/my_string_repository_impl.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/entity/my_string_entity.dart';

class MockLocalDataSource extends Mock implements MyStringLocalDataSource {}
class MockRemoteDataSource extends Mock implements MyStringRemoteDataSource {}

void main() {
  late MyStringRepositoryImpl repo;
  late MockLocalDataSource mockLocal;
  late MockRemoteDataSource mockRemote;

  setUp(() {
    mockLocal = MockLocalDataSource();
    mockRemote = MockRemoteDataSource();
    repo = MyStringRepositoryImpl(localDataSource: mockLocal, remoteDataSource: mockRemote);
  });

  test('getMyStringFromRemote returns MyStringEntity from remote', () async {
    final mockEntity = MyStringEntity(value: 'Remote Result');
    when(() => mockRemote.getMyString()).thenAnswer((_) async => mockEntity);

    final result = await repo.getMyStringFromRemote();

    expect(result.value, 'Remote Result');
    expect(result, isA<MyStringEntity>());
  });
}
