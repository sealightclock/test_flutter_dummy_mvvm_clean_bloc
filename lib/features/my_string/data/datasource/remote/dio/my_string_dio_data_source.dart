import '../../../../../../core/error/app_exception.dart';
import '../../../../../../shared/constants/app_constants.dart';
import '../../../../domain/entity/my_string_entity.dart';
import 'my_string_dio_api.dart';
import '../my_string_remote_data_source.dart';

/// Data Source handler for fetching data from the backend server using dio.
class MyStringDioDataSource implements MyStringRemoteDataSource {
  final MyStringDioApi _api = MyStringDioApi(); // Created once

  /// Fetches data from the server.
  /// If fetching fails, throws `MyStringException`.
  @override
  Future<MyStringEntity> getMyString() async {
    try {
      String content = await _api.fetchContent();
      return MyStringEntity(value: '${AppConstants.prefixDioValue}$content');
    } catch (e) {
      throw AppException('MyStringDioDataSource: Server fetch failed: $e');
    }
  }

  @override
  Future<void> storeMyString(MyStringEntity value) {
    // TODO: implement storeMyString
    throw UnimplementedError();
  }
}
