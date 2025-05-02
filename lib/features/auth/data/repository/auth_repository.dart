import '../../domain/entity/auth_entity.dart';
import '../local/auth_hive_data_source.dart';
import '../remote/auth_remote_data_source.dart';

/// Repository to coordinate between local and remote authentication data sources.
class AuthRepository {
  late final AuthHiveDataSource localDataSource;
  late final AuthRemoteDataSource remoteDataSource;

  AuthRepository({
    required this.localDataSource,
    required this.remoteDataSource
  });

  /// Signup a new user remotely and store locally.
  Future<void> signUp(String username, String password) async {
    final auth = await remoteDataSource.signup(username, password);
    await localDataSource.storeAuth(auth);
  }

  /// Login an existing user remotely and store locally.
  Future<void> login(String username, String password) async {
    final auth = await remoteDataSource.login(username, password);
    await localDataSource.storeAuth(auth);
  }

  /// Guest login remotely and store locally.
  Future<void> guestLogin() async {
    final auth = await remoteDataSource.guestLogin();
    await localDataSource.storeAuth(auth);
  }

  /// Get current user authentication status from local storage.
  Future<AuthEntity> getAuth() async {
    return await localDataSource.getAuth();
  }

  /// Clear stored user authentication after logout.
  Future<void> clearAuth() async {
    await localDataSource.clearAuth();
  }
}
