import '../../data/repository/settings_repository.dart';
import '../entity/settings_entity.dart';

class SaveSettingsUseCase {
  final SettingsRepository repository;

  SaveSettingsUseCase(this.repository);

  Future<void> call(SettingsEntity settings) async {
    await repository.saveSettings(settings);
  }
}

