import '../../domain/entity/user_auth_entity.dart';
import 'auth_client_api.dart';

/// Data source handler to manage authentication remotely via AuthClientApi.
class AuthRemoteDataSource {
  final AuthClientApi _api = AuthClientApi();

  /// Signup user remotely
  Future<UserAuthEntity> signup(String username, String password) async {
    final response = await _api.signup(username, password);
    return UserAuthEntity.fromMap(response);
  }

  /// Login user remotely
  Future<UserAuthEntity> login(String username, String password) async {
    final response = await _api.login(username, password);
    return UserAuthEntity.fromMap(response);
  }

  /// Guest login remotely
  Future<UserAuthEntity> guestLogin() async {
    final response = await _api.guestLogin();
    return UserAuthEntity.fromMap(response);
  }
}
