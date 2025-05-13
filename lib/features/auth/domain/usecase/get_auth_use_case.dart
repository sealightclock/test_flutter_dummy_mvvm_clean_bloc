import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/data/repository/auth_repository.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity'
    '/auth_entity.dart';

import '../../../../app/util/result.dart';

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
