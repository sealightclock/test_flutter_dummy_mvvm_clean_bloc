import '../../data/local/auth_hive_data_source.dart';
import '../../data/remote/auth_remote_data_source.dart';
import '../../data/repository/auth_repository.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../domain/usecase/guest_login_use_case.dart';
import '../../domain/usecase/get_auth_use_case.dart';

/// Factory to create AuthViewModel with all dependencies injected.
class AuthViewModelFactory {
  static AuthViewModel create() {
    final AuthHiveDataSource localDataSource = AuthHiveDataSource();
    final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSource();

    final repository = AuthRepository(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    final loginUseCase = LoginUseCase(repository);
    final signUpUseCase = SignUpUseCase(repository);
    final guestLoginUseCase = GuestLoginUseCase(repository);
    final getAuthUseCase = GetAuthUseCase(repository);

    return AuthViewModel(
      loginUseCase: loginUseCase,
      signUpUseCase: signUpUseCase,
      guestLoginUseCase: guestLoginUseCase,
      getAuthUseCase: getAuthUseCase,
    );
  }
}
