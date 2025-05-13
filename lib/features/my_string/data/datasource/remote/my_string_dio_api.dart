import 'package:dio/dio.dart';

import '../../../../../app/util/app_constants.dart';
import '../../../../../app/util/app_exception.dart';

/// Handles API calls to the backend server using Dio.
/// Includes timeout settings for reliability.
class MyStringDioApi {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  /// Fetches content from the backend server.
  /// Throws a `MyStringException` if the request fails.
  Future<String> fetchContent() async {
    try {
      final response = await _dio.get(AppConstants.backendServerUrl);

      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw AppException('MyStringDioApi: Failed to fetch content: ${response
            .statusCode}');
      }
    } catch (e) {
      throw AppException('MyStringDioApi: Error fetching content: $e');
    }
  }
}
