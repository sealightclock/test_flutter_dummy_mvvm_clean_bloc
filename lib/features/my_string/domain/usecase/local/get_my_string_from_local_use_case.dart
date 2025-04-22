// This UseCase file is responsible for retrieving "my_string" from a local store,
// using the Domain Layer and clean error handling.

import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart';

import '../../../data/repository/my_string_repository.dart';
import '../../entity/my_string_entity.dart';

/// Use Case: Retrieve the stored my_string from a local store.
class GetMyStringFromLocalUseCase {
  final MyStringRepository repository;

  GetMyStringFromLocalUseCase({required this.repository});

  /// Executes the use case.
  ///
  /// Always returns a Result:
  /// - Success with MyStringEntity on success
  /// - Failure with error message on failure
  Future<Result<MyStringEntity>> call() async {
    try {
      final entity = await repository.getMyStringFromLocal();
      return Success(entity);
    } catch (e) {
      return Failure('Failed to get my_string from local: $e');
    }
  }
}
