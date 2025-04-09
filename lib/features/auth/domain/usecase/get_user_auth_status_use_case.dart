import '../../data/repository/auth_repository.dart';
import '../entity/user_auth_entity.dart';

class GetUserAuthStatusUseCase {
  final AuthRepository repository;

  GetUserAuthStatusUseCase(this.repository);

  Future<UserAuthEntity?> call() async {
    return await repository.getUserAuthStatus();
  }
}
