import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../domain/usecase/guest_login_use_case.dart';
import '../../domain/usecase/get_user_auth_status_use_case.dart';
import '../../domain/entity/user_auth_entity.dart';

class AuthViewModel {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final GuestLoginUseCase guestLoginUseCase;
  final GetUserAuthStatusUseCase getUserAuthStatusUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.guestLoginUseCase,
    required this.getUserAuthStatusUseCase,
  });

  Future<void> login(String username, String password) async {
    await loginUseCase(username, password);
  }

  Future<void> signUp(String username, String password) async {
    await signUpUseCase(username, password);
  }

  Future<void> guestLogin() async {
    await guestLoginUseCase();
  }

  Future<UserAuthEntity?> getUserAuthStatus() async {
    return await getUserAuthStatusUseCase();
  }

  /// Clear user authentication status after logout.
  Future<void> clearUserAuthStatus() async {
    final repository = getUserAuthStatusUseCase.repository; // get reference
    await repository.clearUserAuth();
  }
}
