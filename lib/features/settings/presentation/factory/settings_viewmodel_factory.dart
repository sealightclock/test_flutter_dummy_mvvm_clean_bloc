import '../../data/local/settings_hive_data_source.dart';
import '../../data/repository/settings_repository_impl.dart';
import '../../domain/usecase/get_settings_use_case.dart';
import '../../domain/usecase/save_settings_use_case.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsViewModelFactory {
  static SettingsViewModel create() {
    final localDataSource = SettingsHiveDataSource();

    final repository = SettingsRepositoryImpl(localDataSource: localDataSource);

    return SettingsViewModel(
      getSettingsUseCase: GetSettingsUseCase(repository: repository),
      saveSettingsUseCase: SaveSettingsUseCase(repository: repository),
    );
  }
}
