import 'package:http/http.dart' as http;

import '../../../domain/entity/auth_entity.dart';

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

  // TODO: Replace with real http client
  late final http.Client _client;
  static const String _baseUrl = 'https://mockapi.example.com/auth'; // Mock URL for structure

  /// One-time initialization for HTTP client.
  void _initialize() {
    _client = http.Client();
  }

  /// Simulate signup API call
  Future<AuthEntity> signup(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // TODO: In real core, you would POST to server here
    return AuthEntity(username: username, password: password, isLoggedIn: true);
  }

  /// Simulate login API call
  Future<AuthEntity> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // TODO: In real core, you would POST and validate user credentials
    return AuthEntity(username: username, password: password, isLoggedIn: true);
  }

  /// Simulate guest login API call
  Future<AuthEntity> guestLogin() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return AuthEntity(username: 'Guest', password: '', isLoggedIn: true);
  }
}
