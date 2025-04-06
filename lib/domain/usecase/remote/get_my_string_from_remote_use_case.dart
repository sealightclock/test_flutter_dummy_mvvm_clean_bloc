// This UseCase file is responsible for retrieving "my_string" from a remote server,
// using the Domain Layer and clean error handling.

import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart';

import '../../../data/repository/my_string_repository.dart';

/// Use Case: Retrieve the latest my_string from a remote server.
class GetMyStringFromRemoteUseCase {
  final MyStringRepository repository;

  GetMyStringFromRemoteUseCase({required this.repository});

  /// Executes the use case.
  ///
  /// Always returns a Result:
  /// - Success with MyStringEntity on success
  /// - Failure with error message on failure
  Future<Result<MyStringEntity>> execute() async {
    try {
      final entity = await repository.getMyStringFromRemote();
      return Success(entity);
    } catch (e) {
      return Failure('Failed to get my_string from remote: $e');
    }
  }
}
