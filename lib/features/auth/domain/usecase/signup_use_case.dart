import '../../data/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<void> call(String username, String password) async {
    await repository.signUp(username, password);
  }
}
