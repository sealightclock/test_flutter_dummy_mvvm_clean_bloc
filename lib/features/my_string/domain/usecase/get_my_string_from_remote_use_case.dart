// This UseCase file is responsible for retrieving "my_string" from a remote server,
// using the Domain Layer and clean error handling.

import '../../../../util/result.dart';
import '../../data/repository/my_string_repository.dart';
import '../entity/my_string_entity.dart';

/// Use Case: Retrieve the latest my_string from a remote server.
class GetMyStringFromRemoteUseCase {
  final MyStringRepository repository;

  GetMyStringFromRemoteUseCase({required this.repository});

  /// Executes the use case.
  ///
  /// Always returns a Result:
  /// - Success with MyStringEntity on success
  /// - Failure with error message on failure
  Future<Result<MyStringEntity>> call() async {
    try {
      final entity = await repository.getMyStringFromRemote();
      return Success(entity);
    } catch (e) {
      return Failure('Failed to get my_string from remote: $e');
    }
  }
}
