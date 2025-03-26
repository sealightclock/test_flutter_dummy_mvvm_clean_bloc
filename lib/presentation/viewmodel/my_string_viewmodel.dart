import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/get_my_string_from_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/local/store_my_string_to_local_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/usecase/remote/get_my_string_from_remote_use_case.dart';

class MyStringViewModel {
  final GetMyStringFromLocalUseCase getLocalUseCase;
  final StoreMyStringToLocalUseCase storeLocalUseCase;
  final GetMyStringFromRemoteUseCase getRemoteUseCase;

  MyStringViewModel({
    required this.getLocalUseCase,
    required this.storeLocalUseCase,
    required this.getRemoteUseCase,
  });

  Future<String> getMyStringFromLocal() async {
    final entity = await getLocalUseCase.execute();
    return entity.value;
  }

  Future<void> storeMyStringToLocal(String value) async {
    await storeLocalUseCase.execute(MyStringEntity(value: value));
  }

  Future<String> getMyStringFromRemote() async {
    final entity = await getRemoteUseCase.execute();
    return entity.value;
  }
}
