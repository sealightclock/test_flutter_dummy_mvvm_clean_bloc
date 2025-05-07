import '../../../../util/result.dart';
import '../../domain/entity/my_string_entity.dart';
import '../../domain/usecase/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/get_my_string_from_remote_use_case.dart';
import '../../domain/usecase/store_my_string_to_local_use_case.dart';

/// ViewModel that communicates with the Domain layer.
///
/// It provides simple methods that the Bloc/UI can call to trigger UseCases.
class MyStringViewModel {
  final GetMyStringFromLocalUseCase getMyStringFromLocalUseCase;
  final StoreMyStringToLocalUseCase storeMyStringToLocalUseCase;
  final GetMyStringFromRemoteUseCase getMyStringFromRemoteUseCase;

  MyStringViewModel({
    required this.getMyStringFromLocalUseCase,
    required this.storeMyStringToLocalUseCase,
    required this.getMyStringFromRemoteUseCase,
  });

  /// Fetch my_string from the local store.
  ///
  /// You can handle the result easily using [handleResult] if needed.
  Future<Result<MyStringEntity>> getMyStringFromLocal() async {
    return await getMyStringFromLocalUseCase.call();
  }

  /// Store my_string to the local store.
  ///
  /// Always returns a Result:
  /// - Success on storing successfully
  /// - Failure if storing failed
  Future<Result<void>> storeMyStringToLocal(String value) async {
    return await storeMyStringToLocalUseCase.call(MyStringEntity(value: value));
  }

  /// Fetch my_string from the remote server.
  ///
  /// You can handle the result easily using [handleResult] if needed.
  Future<Result<MyStringEntity>> getMyStringFromRemote() async {
    return await getMyStringFromRemoteUseCase.call();
  }
}
