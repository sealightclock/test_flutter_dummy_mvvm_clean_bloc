import '../../data/local/settings_local_data_source.dart';
import '../../data/repository/settings_repository_impl.dart';
import '../../domain/usecase/get_settings_use_case.dart';
import '../../domain/usecase/save_settings_use_case.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsViewModelFactory {
  static SettingsViewModel create() {
    final localDataSource = SettingsLocalDataSource();
    final repository = SettingsRepositoryImpl(localDataSource);
    return SettingsViewModel(
      getSettingsUseCase: GetSettingsUseCase(repository),
      saveSettingsUseCase: SaveSettingsUseCase(repository),
    );
  }
}
