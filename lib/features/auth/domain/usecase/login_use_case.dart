import '../../../../util/result.dart';
import '../../data/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Result<void>> call(String username, String password) async {
    try {
      await repository.login(username, password);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to login: \$e');
    }
  }
}
