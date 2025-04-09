import '../../../../util/result.dart';
import '../../domain/entity/user_auth_entity.dart';
import '../local/auth_local_data_source.dart';

class AuthRepository {
  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();

  Future<Result<void>> login(String username, String password) async {
    try {
      // Simulate a login API call or database call
      await Future.delayed(const Duration(seconds: 1));

      // You assume login is successful for now
      return Success(null);
    } catch (e) {
      return Failure('Login failed: $e');
    }
  }

  Future<Result<void>> signUp(String username, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return Success(null);
    } catch (e) {
      return Failure('Signup failed: $e');
    }
  }

  Future<Result<void>> guestLogin() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return Success(null);
    } catch (e) {
      return Failure('Guest login failed: $e');
    }
  }

  Future<UserAuthEntity?> getUserAuthStatus() async {
    return await _localDataSource.getUser();
  }
}
