import '../../domain/entity/my_string_entity.dart';

/// This top-level interface or abstract class is for data sources in a remote
/// store.
abstract class MyStringRemoteDataSource {
  Future<MyStringEntity> getMyString();
  Future<void> storeMyString(MyStringEntity value);
}
