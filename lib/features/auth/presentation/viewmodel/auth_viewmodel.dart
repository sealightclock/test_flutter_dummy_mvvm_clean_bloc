import '../../../../util/result.dart';
import '../../domain/entity/user_auth_entity.dart';

abstract class AuthViewModel {
  Future<Result<void>> login(String username, String password);
  Future<Result<void>> signUp(String username, String password);
  Future<Result<void>> guestLogin();
  Future<UserAuthEntity?> getUserAuthStatus();
}
