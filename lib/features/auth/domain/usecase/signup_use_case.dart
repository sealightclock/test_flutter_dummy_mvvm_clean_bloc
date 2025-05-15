import '../../../../core/util/result/result.dart';
import '../../data/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<Result<void>> call(String username, String password) async {
    try {
      await repository.signUp(username, password);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to signUp: \$e');
    }
  }
}
