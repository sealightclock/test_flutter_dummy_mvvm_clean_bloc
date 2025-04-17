import '../../../settings/domain/usecase/get_settings_use_case.dart';
import '../../../settings/domain/usecase/save_settings_use_case.dart';
import '../../../settings/domain/entity/settings_entity.dart';

class SettingsViewModel {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  SettingsViewModel({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  });

  Future<SettingsEntity> getSettings() async {
    return await getSettingsUseCase.execute();
  }

  Future<void> saveSettings(SettingsEntity settings) async {
    await saveSettingsUseCase(settings);
  }
}
