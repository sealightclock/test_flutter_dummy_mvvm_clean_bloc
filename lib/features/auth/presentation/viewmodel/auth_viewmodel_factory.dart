import '../../data/datasource/local/auth_hive_data_source.dart';
import '../../data/datasource/remote/auth_remote_data_source.dart';
import '../../data/repository/auth_repository.dart';
import '../../domain/usecase/get_auth_use_case.dart';
import '../../domain/usecase/guest_login_use_case.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/logout_use_case.dart';
import '../../domain/usecase/signup_use_case.dart';
import 'auth_viewmodel.dart';

/// Factory to create AuthViewModel with all dependencies injected.
class AuthViewModelFactory {
  static AuthViewModel create() {
    final AuthHiveDataSource localDataSource = AuthHiveDataSource();
    final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSource();

    final repository = AuthRepository(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    final loginUseCase = LoginUseCase(repository: repository);
    final signUpUseCase = SignUpUseCase(repository: repository);
    final guestLoginUseCase = GuestLoginUseCase(repository: repository);
    final getAuthUseCase = GetAuthUseCase(repository: repository);
    final logoutUseCase = LogoutUseCase(repository: repository);

    return AuthViewModel(
      loginUseCase: loginUseCase,
      signUpUseCase: signUpUseCase,
      guestLoginUseCase: guestLoginUseCase,
      getAuthUseCase: getAuthUseCase,
      logoutUseCase: logoutUseCase,
    );
  }
}
