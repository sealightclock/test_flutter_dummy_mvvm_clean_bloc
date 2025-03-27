import '../../../data/repository/my_string_repository.dart';
import '../../entity/my_string_entity.dart';

/// Use Case: Store a string into a local store.
class StoreMyStringToLocalUseCase {
  final MyStringRepository repository;

  StoreMyStringToLocalUseCase({required this.repository});

  Future<void> execute(MyStringEntity value) async {
    repository.storeMyStringToLocal(value);
  }
}
