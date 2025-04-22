import '../../domain/entity/auth_entity.dart';
import '../local/auth_hive_data_source.dart';
import '../remote/auth_remote_data_source.dart';

/// Repository to coordinate between local and remote authentication data sources.
class AuthRepository {
  final AuthHiveDataSource _localDataSource = AuthHiveDataSource();
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();

  /// Signup a new user remotely and store locally.
  Future<void> signUp(String username, String password) async {
    final auth = await _remoteDataSource.signup(username, password);
    await _localDataSource.storeAuth(auth);
  }

  /// Login an existing user remotely and store locally.
  Future<void> login(String username, String password) async {
    final auth = await _remoteDataSource.login(username, password);
    await _localDataSource.storeAuth(auth);
  }

  /// Guest login remotely and store locally.
  Future<void> guestLogin() async {
    final auth = await _remoteDataSource.guestLogin();
    await _localDataSource.storeAuth(auth);
  }

  /// Get current user authentication status from local storage.
  Future<AuthEntity> getAuth() async {
    return await _localDataSource.getAuth();
  }

  /// Clear stored user authentication after logout.
  Future<void> clearAuth() async {
    await _localDataSource.clearAuth();
  }
}
