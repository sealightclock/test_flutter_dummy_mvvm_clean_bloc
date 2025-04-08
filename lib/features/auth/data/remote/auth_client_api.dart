import 'package:http/http.dart' as http;

/// Client API to simulate remote server for authentication.
/// In real case, replace mock implementations with real http requests.
class AuthClientApi {
  static final AuthClientApi _instance = AuthClientApi._internal();

  factory AuthClientApi() {
    return _instance;
  }

  AuthClientApi._internal() {
    _initialize();
  }

  late final http.Client _client;
  static const String _baseUrl = 'https://mockapi.example.com/auth'; // Mock URL for structure

  /// One-time initialization for HTTP client.
  void _initialize() {
    _client = http.Client();
  }

  /// Simulate signup API call
  Future<Map<String, dynamic>> signup(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // In real app, you would POST to server here
    return {
      'username': username,
      'password': password,
      'isLoggedIn': true,
    };
  }

  /// Simulate login API call
  Future<Map<String, dynamic>> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // In real app, you would POST and validate user credentials
    return {
      'username': username,
      'password': password,
      'isLoggedIn': true,
    };
  }

  /// Simulate guest login API call
  Future<Map<String, dynamic>> guestLogin() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return {
      'username': 'Guest',
      'password': '',
      'isLoggedIn': true,
    };
  }
}
