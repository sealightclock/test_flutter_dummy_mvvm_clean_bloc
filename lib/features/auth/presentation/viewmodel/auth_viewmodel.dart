import '../../../../util/result.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../domain/usecase/guest_login_use_case.dart';
import '../../domain/usecase/get_auth_use_case.dart';
import '../../domain/entity/auth_entity.dart';

class AuthViewModel {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final GuestLoginUseCase guestLoginUseCase;
  final GetAuthUseCase getAuthUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.guestLoginUseCase,
    required this.getAuthUseCase,
  });

  Future<Result<void>> login(String username, String password) async {
    return await loginUseCase(username, password);
  }

  Future<Result<void>> signUp(String username, String password) async {
    return await signUpUseCase(username, password);
  }

  Future<Result<void>> guestLogin() async {
    return await guestLoginUseCase.call();
  }

  Future<Result<AuthEntity>> getAuth() async {
    return await getAuthUseCase.call();
  }

  /// Clear user authentication status after logout.
  Future<void> clearAuth() async {
    final repository = getAuthUseCase.repository; // get reference
    await repository.clearAuth();
  }
}
