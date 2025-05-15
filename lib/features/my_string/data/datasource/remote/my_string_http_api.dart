import 'package:http/http.dart' as http;

import '../../../../../core/util/constants/app_constants.dart';
import '../../../../../core/util/error/app_exception.dart';

/// Handles API calls to the backend server using the http package.
/// Includes timeout settings for reliability.
class MyStringHttpApi {
  /// Fetches content from the backend server.
  /// Throws a `MyStringException` if the request fails.
  Future<String> fetchContent() async {
    try {
      final response = await http
          .get(Uri.parse(AppConstants.backendServerUrl))
          .timeout(Duration(seconds: 5)); // Timeout for reliability

      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw AppException('MyStringHttpApi: Failed to fetch content: ${response
            .statusCode}');
      }
    } catch (e) {
      throw AppException('MyStringHttpApi: Error fetching content: $e');
    }
  }
}
