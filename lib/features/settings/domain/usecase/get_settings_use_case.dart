import '../entity/settings_entity.dart';
import '../../data/repository/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  Future<SettingsEntity> execute() {
    return repository.getSettings();
  }
}