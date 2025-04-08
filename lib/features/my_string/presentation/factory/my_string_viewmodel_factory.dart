import '../../data/di/my_string_dependency_injection.dart';
import '../../data/repository/my_string_repository_impl.dart';
import '../../domain/usecase/local/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/local/store_my_string_to_local_use_case.dart';
import '../../domain/usecase/remote/get_my_string_from_remote_use_case.dart';
import '../viewmodel/my_string_viewmodel.dart';

/// This creates the ViewModel from ground up:
/// Data Sources -> Repository -> Use Cases -> ViewModel
MyStringViewModel createViewModel() {
  // Create Data Sources using Dependency Injection (DI)
  final localDataSource = createLocalDataSource(storeTypeSelected);
  final remoteDataSource = createRemoteDataSource(serverTypeSelected);

  // Create Repository
  final repository = MyStringRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  // Create Use Cases
  final getMyStringFromLocalUseCase = GetMyStringFromLocalUseCase(repository: repository);
  final storeMyStringToLocalUseCase = StoreMyStringToLocalUseCase(repository: repository);
  final getMyStringFromRemoteUseCase = GetMyStringFromRemoteUseCase(repository: repository);

  // Finally, create ViewModel
  return MyStringViewModel(
    getFromLocalUseCase: getMyStringFromLocalUseCase,
    storeToLocalUseCase: storeMyStringToLocalUseCase,
    getFromRemoteUseCase: getMyStringFromRemoteUseCase,
  );
}
