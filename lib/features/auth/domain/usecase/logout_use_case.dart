import '../../../../core/util/result/result.dart';
import '../../data/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Result<void>> call() async {
    try {
      await repository.clearAuth();
      return const Success(null);
    } catch (e) {
      return Failure('Failed to clearAuth: \$e');
    }
  }
}
