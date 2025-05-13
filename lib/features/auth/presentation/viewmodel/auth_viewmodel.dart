import '../../../../app/util/result/result.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../domain/usecase/guest_login_use_case.dart';
import '../../domain/usecase/get_auth_use_case.dart';
import '../../domain/usecase/logout_use_case.dart';
import '../../domain/entity/auth_entity.dart';

class AuthViewModel {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final GuestLoginUseCase guestLoginUseCase;
  final GetAuthUseCase getAuthUseCase;
  final LogoutUseCase logoutUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.guestLoginUseCase,
    required this.getAuthUseCase,
    required this.logoutUseCase,
  });

  Future<Result<void>> login(String username, String password) async {
    return await loginUseCase.call(username, password);
  }

  Future<Result<void>> signUp(String username, String password) async {
    return await signUpUseCase.call(username, password);
  }

  Future<Result<void>> guestLogin() async {
    return await guestLoginUseCase.call();
  }

  Future<Result<AuthEntity>> getAuth() async {
    return await getAuthUseCase.call();
  }

  // TODO: This is actually a UseCase for feature "account", not "auth".
  //   However, we put it here for simplicity: The "account" feature does not
  //   even need a separate ViewModel.
  //
  //   We may need to revisit this.
  /// Clear user authentication status after logout.
  Future<Result<void>> clearAuth() async {
    return await logoutUseCase.call();
  }
}
