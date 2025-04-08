import '../../domain/entity/user_auth_entity.dart';
import '../local/auth_local_data_source.dart';
import '../remote/auth_remote_data_source.dart';

/// Repository to coordinate between local and remote authentication data sources.
class AuthRepository {
  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();

  /// Signup a new user remotely and store locally.
  Future<void> signUp(String username, String password) async {
    final user = await _remoteDataSource.signup(username, password);
    await _localDataSource.storeUser(user);
  }

  /// Login an existing user remotely and store locally.
  Future<void> login(String username, String password) async {
    final user = await _remoteDataSource.login(username, password);
    await _localDataSource.storeUser(user);
  }

  /// Guest login remotely and store locally.
  Future<void> guestLogin() async {
    final user = await _remoteDataSource.guestLogin();
    await _localDataSource.storeUser(user);
  }

  /// Get current user authentication status from local storage.
  Future<UserAuthEntity?> getUserAuthStatus() async {
    return await _localDataSource.getUser();
  }
}
