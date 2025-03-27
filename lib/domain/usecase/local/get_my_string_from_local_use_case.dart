import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';

import '../../../data/repository/my_string_repository.dart';

/// Use Case: Retrieve the stored string from a local store.
class GetMyStringFromLocalUseCase {
  final MyStringRepository repository;

  GetMyStringFromLocalUseCase({required this.repository});

  Future<MyStringEntity> execute() {
    return repository.getMyStringFromLocal();
  }
}
