import '../../../../util/result.dart';
import '../../domain/entity/my_string_entity.dart';
import '../../domain/usecase/local/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/local/store_my_string_to_local_use_case.dart';
import '../../domain/usecase/remote/get_my_string_from_remote_use_case.dart';

/// ViewModel that communicates with the Domain layer.
///
/// It provides simple methods that the Bloc/UI can call to trigger UseCases.
class MyStringViewModel {
  final GetMyStringFromLocalUseCase getFromLocalUseCase;
  final StoreMyStringToLocalUseCase storeToLocalUseCase;
  final GetMyStringFromRemoteUseCase getFromRemoteUseCase;

  MyStringViewModel({
    required this.getFromLocalUseCase,
    required this.storeToLocalUseCase,
    required this.getFromRemoteUseCase,
  });

  /// Fetch my_string from the local store.
  ///
  /// You can handle the result easily using [handleResult] if needed.
  Future<Result<MyStringEntity>> getMyStringFromLocal() async {
    return await getFromLocalUseCase.execute();
  }

  /// Store my_string to the local store.
  ///
  /// Always returns a Result:
  /// - Success on storing successfully
  /// - Failure if storing failed
  Future<Result<void>> storeMyStringToLocal(String value) async {
    return await storeToLocalUseCase.execute(MyStringEntity(value: value));
  }

  /// Fetch my_string from the remote server.
  ///
  /// You can handle the result easily using [handleResult] if needed.
  Future<Result<MyStringEntity>> getMyStringFromRemote() async {
    return await getFromRemoteUseCase.execute();
  }
}
