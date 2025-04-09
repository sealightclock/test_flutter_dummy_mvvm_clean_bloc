import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity/user_auth_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart';

/// A fake AuthViewModel used only for integration tests.
class TestAuthViewModel implements AuthViewModel {
  @override
  Future<Result<void>> login(String username, String password) async {
    return Success<void>(null); // ✅ must return non-nullable Result<void>
  }

  @override
  Future<Result<void>> signUp(String username, String password) async {
    return Success<void>(null);
  }

  @override
  Future<Result<void>> guestLogin() async {
    return Success<void>(null);
  }

  @override
  Future<UserAuthEntity?> getUserAuthStatus() async {
    return UserAuthEntity(username: 'guest', isLoggedIn: true, password: '');
  }
}
