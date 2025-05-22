import '../../../../shared/di/di_config.dart';
import '../../../../shared/di/di_initializer.dart';
import '../../data/datasource/di/my_string_di.dart';
import '../../data/repository/my_string_repository_impl.dart';
import '../../domain/usecase/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/get_my_string_from_remote_use_case.dart';
import '../../domain/usecase/store_my_string_to_local_use_case.dart';
import '../viewmodel/my_string_viewmodel.dart';

/// Factory class to create the MyStringViewModel from ground up:
/// Data Sources → Repository → Use Cases → ViewModel
class MyStringViewModelFactory {
  /// Static method to create a fully wired-up MyStringViewModel
  ///
  /// This method uses manual Dependency Injection (DI) to select the desired
  /// local and remote data sources, then wires them into a repository.
  /// The repository handles all conversions and is then passed to Use Cases,
  /// which are in turn passed to the ViewModel.
  static MyStringViewModel create() {
    // Initialize DI configuration, such as selecting Hive or SharedPrefs.
    DiInitializer.init();

    // Create local and remote data sources using factory methods.
    // SharedPrefs → localDataSource; Hive → hiveDataSource.
    final localDataSource = createLocalDataSource(DiConfig.localStore);
    final hiveDataSource = createHiveDtoDataSource(DiConfig.localStore);
    final remoteDataSource = createRemoteDataSource(DiConfig.remoteServer);

    // Create the repository, which bridges domain and data layers.
    // It will handle DTO ↔ Entity conversion if needed.
    final repository = MyStringRepositoryImpl(
      localDataSource: localDataSource,
      hiveDataSource: hiveDataSource,
      remoteDataSource: remoteDataSource,
    );

    // Create Use Cases that expose specific business actions.
    final getMyStringFromLocalUseCase =
    GetMyStringFromLocalUseCase(repository: repository);
    final storeMyStringToLocalUseCase =
    StoreMyStringToLocalUseCase(repository: repository);
    final getMyStringFromRemoteUseCase =
    GetMyStringFromRemoteUseCase(repository: repository);

    // Finally, create the ViewModel that connects the UI with the use cases.
    return MyStringViewModel(
      getMyStringFromLocalUseCase: getMyStringFromLocalUseCase,
      storeMyStringToLocalUseCase: storeMyStringToLocalUseCase,
      getMyStringFromRemoteUseCase: getMyStringFromRemoteUseCase,
    );
  }
}
