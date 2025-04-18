import 'package:test_flutter_dummy_mvvm_clean_bloc/util/di_config.dart';

import '../../../../util/di_initializer.dart';
import '../../data/di/my_string_dependency_injection.dart';
import '../../data/repository/my_string_repository_impl.dart';
import '../../domain/usecase/local/get_my_string_from_local_use_case.dart';
import '../../domain/usecase/local/store_my_string_to_local_use_case.dart';
import '../../domain/usecase/remote/get_my_string_from_remote_use_case.dart';
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
      getFromLocalUseCase: getMyStringFromLocalUseCase,
      storeToLocalUseCase: storeMyStringToLocalUseCase,
      getFromRemoteUseCase: getMyStringFromRemoteUseCase,
    );
  }
}
