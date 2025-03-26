import '../../domain/entity/my_string_entity.dart';
import '../../util/my_string_exception.dart';
import 'my_string_http_api.dart';
import 'my_string_remote_data_source.dart';

/// Data Source handler for fetching data from the backend server using http.
class MyStringHttpDataSource implements MyStringRemoteDataSource {
  /// Fetches data from the server.
  /// If fetching fails, throws `MyStringException`.
  @override
  Future<MyStringEntity> getMyString() async {
    try {
      String content = await MyStringHttpApi().fetchContent();
      return MyStringEntity(value: 'MyStringHttpDataSource: Server String: '
          '$content');
    } catch (e) {
      throw MyStringException('MyStringHttpDataSource: Server fetch failed: $e');
    }
  }

  @override
  Future<void> storeMyString(MyStringEntity value) {
    // TODO: Implement storeMyString
    throw UnimplementedError();
  }
}
