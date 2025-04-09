import '../../data/repository/auth_repository.dart';
import '../../../../util/result.dart'; // Add this if not imported yet

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Result<void>> execute(String username, String password) async {
    return await repository.login(username, password);
  }
}
