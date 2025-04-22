// This UseCase file is responsible for storing "my_string" into a local store,
// using the Domain Layer and clean error handling.

import '../../../../../util/result.dart';
import '../../../data/repository/my_string_repository.dart';
import '../../entity/my_string_entity.dart';

/// Use Case: Store a new value of my_string into a local store.
class StoreMyStringToLocalUseCase {
  final MyStringRepository repository;

  StoreMyStringToLocalUseCase({required this.repository});

  /// Executes the use case.
  ///
  /// Always returns a Result:
  /// - Success with void (no data needed) on success
  /// - Failure with error message on failure
  Future<Result<void>> call(MyStringEntity value) async {
    try {
      await repository.storeMyStringToLocal(value);
      return const Success(null); // Success but no data
    } catch (e) {
      return Failure('Failed to store my_string to local: $e');
    }
  }
}
