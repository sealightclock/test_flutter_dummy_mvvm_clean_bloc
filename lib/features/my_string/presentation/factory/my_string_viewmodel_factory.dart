import '../../../../app/di/di_config.dart';
import '../../../../app/di/di_initializer.dart';
import '../../../../app/di/my_string_di.dart';
import '../../data/repository/my_string_repository_impl.dart';
import '../../domain/usecase/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/get_my_string_from_remote_use_case.dart';
import '../../domain/usecase/store_my_string_to_local_use_case.dart';
import '../viewmodel/my_string_viewmodel.dart';

/// Factory class to create the MyStringViewModel from ground up:
/// Data Sources -> Repository -> Use Cases -> ViewModel
class MyStringViewModelFactory {
  /// Static method to create a fully wired-up MyStringViewModel
  static MyStringViewModel create() {
    // Create Data Sources using Dependency Injection (DI)
    // For now: Configure DI to use Hive and Simulator, manually.
    // TODO: In the future, find a better way:
    DiInitializer.init();

    final localDataSource = createLocalDataSource(DiConfig.localStore);
    final remoteDataSource = createRemoteDataSource(DiConfig.remoteServer);

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
      getMyStringFromLocalUseCase: getMyStringFromLocalUseCase,
      storeMyStringToLocalUseCase: storeMyStringToLocalUseCase,
      getMyStringFromRemoteUseCase: getMyStringFromRemoteUseCase,
    );
  }
}
