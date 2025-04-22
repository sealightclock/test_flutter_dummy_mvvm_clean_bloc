import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/data/repository/auth_repository.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity'
    '/auth_entity.dart';

class GetAuthUseCase {
  final AuthRepository repository;

  GetAuthUseCase(this.repository);

  Future<AuthEntity?> call() async {
    return await repository.getAuth();
  }
}
