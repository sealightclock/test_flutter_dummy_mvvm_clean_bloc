import '../../domain/entity/my_string_entity.dart';

/// Since there are multiple data sources, we need to define a top-level
/// repository or interface or abstract class.
/// Usually we need to access data from a local store and a remote server.
abstract class MyStringRepository {
  Future<MyStringEntity> getMyStringFromLocal();
  Future<void> storeMyStringToLocal(MyStringEntity value);

  Future<MyStringEntity> getMyStringFromRemote();
}
