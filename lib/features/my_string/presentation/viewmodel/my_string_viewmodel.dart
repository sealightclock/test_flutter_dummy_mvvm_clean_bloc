import '../../../../core/result/result.dart';
import '../../domain/usecase/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/get_my_string_from_remote_use_case.dart';
import '../../domain/usecase/store_my_string_to_local_use_case.dart';
import '../model/my_string_model.dart';
import '../model/my_string_ui_mapper.dart'; // ✅ Import mapper

/// ViewModel that communicates with the Domain layer.
///
/// It provides methods for the UI to interact with the app logic.
/// All conversions between Entity and Model are delegated to [MyStringUiMapper].
class MyStringViewModel {
  final GetMyStringFromLocalUseCase getMyStringFromLocalUseCase;
  final StoreMyStringToLocalUseCase storeMyStringToLocalUseCase;
  final GetMyStringFromRemoteUseCase getMyStringFromRemoteUseCase;

  MyStringViewModel({
    required this.getMyStringFromLocalUseCase,
    required this.storeMyStringToLocalUseCase,
    required this.getMyStringFromRemoteUseCase,
  });

  /// Fetch my_string from local storage and convert it to Model for UI.
  Future<Result<MyStringModel>> getMyStringFromLocal() async {
    final result = await getMyStringFromLocalUseCase.call();
    return result.map(MyStringUiMapper.toModel);
  }

  /// Store a UI model to local storage after converting to Entity.
  Future<Result<void>> storeMyStringToLocal(MyStringModel model) async {
    final entity = MyStringUiMapper.toEntity(model);
    return await storeMyStringToLocalUseCase.call(entity);
  }

  /// Fetch my_string from remote server and convert it to Model for UI.
  Future<Result<MyStringModel>> getMyStringFromRemote() async {
    final result = await getMyStringFromRemoteUseCase.call();
    return result.map(MyStringUiMapper.toModel);
  }
}
