import 'package:mocktail/mocktail.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity/user_auth_entity.dart';

/// Fake AuthViewModel for widget tests and integration tests
class FakeAuthViewModel extends Mock implements AuthViewModel {
  @override
  Future<Result<void>> login(String username, String password) async {
    return Success(null);
  }

  @override
  Future<Result<void>> signUp(String username, String password) async {
    return Success(null);
  }

  @override
  Future<Result<void>> guestLogin() async {
    return Success(null);
  }

  @override
  Future<UserAuthEntity?> getUserAuthStatus() async {
    return UserAuthEntity(
      username: 'fake_user',
      password: 'fake_password',
      isLoggedIn: false,
    );
  }
}
