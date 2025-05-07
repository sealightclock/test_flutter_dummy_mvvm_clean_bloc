import '../../../domain/entity/auth_entity.dart';
import 'auth_client_api.dart';

/// Data source handler to manage authentication remotely via AuthClientApi.
class AuthRemoteDataSource {
  final AuthClientApi _api = AuthClientApi();

  /// Signup user remotely
  Future<AuthEntity> signup(String username, String password) async {
    final response = await _api.signup(username, password);
    return response;
  }

  /// Login user remotely
  Future<AuthEntity> login(String username, String password) async {
    final response = await _api.login(username, password);
    return response;
  }

  /// Guest login remotely
  Future<AuthEntity> guestLogin() async {
    final response = await _api.guestLogin();
    return response;
  }
}
