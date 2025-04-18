import '../../domain/entity/settings_entity.dart';
import '../local/settings_hive_data_source.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsHiveDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<SettingsEntity> getSettings() {
    return localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) {
    return localDataSource.saveSettings(settings);
  }
}
