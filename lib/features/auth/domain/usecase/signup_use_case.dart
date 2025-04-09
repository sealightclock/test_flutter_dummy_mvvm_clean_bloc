import '../../../../util/result.dart';
import '../../data/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Result<void>> execute(String username, String password) {
    return repository.signUp(username, password);
  }
}
