import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';

import '../../../data/repository/my_string_repository.dart';

/// Use Case: Retrieve the latest my_string from a remote server.
class GetMyStringFromRemoteUseCase {
  final MyStringRepository repository;

  GetMyStringFromRemoteUseCase({required this.repository});

  /// execute() is commonly used in Use Cases to execute the use case.
  /// Do not use "await" if we are not modifying the value:
  Future<MyStringEntity> execute() async => repository.getMyStringFromRemote();
}
