import '../../domain/entity/my_string_entity.dart';
import '../local/my_string_local_data_source.dart';
import '../remote/my_string_remote_data_source.dart';
import 'my_string_repository.dart';

/// This 2nd-level repository implementation is responsible for dealing with
/// various data sources (local and remote).
/// Note that each local/remote data source can have a different format and
/// access mechanism, which implies that we'll need to have a 3rd-layer.
class MyStringRepositoryImpl implements MyStringRepository {
  late final MyStringLocalDataSource localDataSource;
  late final MyStringRemoteDataSource remoteDataSource;

  MyStringRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<MyStringEntity> getMyStringFromLocal() {
    return localDataSource.getMyString();
  }

  @override
  Future<void> storeMyStringToLocal(MyStringEntity value) async {
    localDataSource.storeMyString(value);
  }

  @override
  Future<MyStringEntity> getMyStringFromRemote() {
    return remoteDataSource.getMyString();
  }
}
