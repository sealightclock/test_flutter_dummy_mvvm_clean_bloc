import '../../../../../../core/error/app_exception.dart';
import '../../../../../../shared/constants/app_constants.dart';
import '../../../../domain/entity/my_string_entity.dart';
import 'my_string_http_api.dart';
import '../my_string_remote_data_source.dart';

/// Data Source handler for fetching data from the backend server using http.
class MyStringHttpDataSource implements MyStringRemoteDataSource {
  final MyStringHttpApi _api = MyStringHttpApi(); // Created once

  /// Fetches data from the server.
  /// If fetching fails, throws `MyStringException`.
  @override
  Future<MyStringEntity> getMyString() async {
    try {
      String content = await _api.fetchContent();
      return MyStringEntity(value: '${AppConstants.prefixHttpValue}$content');
    } catch (e) {
      throw AppException('MyStringHttpDataSource: Server fetch failed: $e');
    }
  }

  @override
  Future<void> storeMyString(MyStringEntity value) {
    // TODO: Implement storeMyString
    throw UnimplementedError();
  }
}
