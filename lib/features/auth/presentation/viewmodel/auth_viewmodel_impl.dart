import '../../../../util/result.dart';
import '../../domain/entity/user_auth_entity.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../domain/usecase/guest_login_use_case.dart';
import '../../domain/usecase/get_user_auth_status_use_case.dart';
import 'auth_viewmodel.dart';

/// Concrete implementation of AuthViewModel.
class AuthViewModelImpl implements AuthViewModel {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final GuestLoginUseCase guestLoginUseCase;
  final GetUserAuthStatusUseCase getUserAuthStatusUseCase;

  AuthViewModelImpl({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.guestLoginUseCase,
    required this.getUserAuthStatusUseCase,
  });

  @override
  Future<Result<void>> login(String username, String password) {
    return loginUseCase.execute(username, password);
  }

  @override
  Future<Result<void>> signUp(String username, String password) {
    return signUpUseCase.execute(username, password);
  }

  @override
  Future<Result<void>> guestLogin() {
    return guestLoginUseCase.execute();
  }

  @override
  Future<UserAuthEntity?> getUserAuthStatus() {
    return getUserAuthStatusUseCase.execute();
  }
}
