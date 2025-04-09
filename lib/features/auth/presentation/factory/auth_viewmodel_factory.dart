import '../../data/repository/auth_repository.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../domain/usecase/guest_login_use_case.dart';
import '../../domain/usecase/get_user_auth_status_use_case.dart';
import '../viewmodel/auth_viewmodel_impl.dart'; // <-- ADD this import!

/// Factory to create AuthViewModel with all dependencies injected.
class AuthViewModelFactory {
  static AuthViewModel create() {
    final repository = AuthRepository();
    return AuthViewModelImpl( // <-- change to AuthViewModelImpl
      loginUseCase: LoginUseCase(repository),
      signUpUseCase: SignUpUseCase(repository),
      guestLoginUseCase: GuestLoginUseCase(repository),
      getUserAuthStatusUseCase: GetUserAuthStatusUseCase(repository),
    );
  }
}
