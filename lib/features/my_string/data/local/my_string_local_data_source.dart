import '../../domain/entity/my_string_entity.dart';

/// This top-level interface or abstract class is for data sources in a local
/// data store.
abstract class MyStringLocalDataSource {
  Future<MyStringEntity> getMyString();
  Future<void> storeMyString(MyStringEntity value);
}
