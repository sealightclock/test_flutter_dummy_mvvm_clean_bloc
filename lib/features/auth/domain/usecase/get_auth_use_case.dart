import '../../../../core/util/result/result.dart';
import '../../data/repository/auth_repository.dart';
import '../entity/auth_entity.dart';

class GetAuthUseCase {
  final AuthRepository repository;

  GetAuthUseCase({required this.repository});

  Future<Result<AuthEntity>> call() async {
    try {
      final auth = await repository.getAuth();
      return Success(auth);
    } catch (e) {
      return Failure('Failed to getAuth: $e');
    }
  }
}
