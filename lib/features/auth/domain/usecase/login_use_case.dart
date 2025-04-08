import '../../data/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<void> call(String username, String password) async {
    await repository.login(username, password);
  }
}
