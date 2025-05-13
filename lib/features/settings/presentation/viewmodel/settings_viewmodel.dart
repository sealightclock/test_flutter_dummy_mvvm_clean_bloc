import '../../../../app/util/result/result.dart';
import '../../../settings/domain/entity/settings_entity.dart';
import '../../../settings/domain/usecase/get_settings_use_case.dart';
import '../../../settings/domain/usecase/save_settings_use_case.dart';

/// ViewModel to handle Settings business logic.
///
/// It wraps the use cases and returns [Result] objects,
/// so the UI or BLoC can handle success/failure cleanly without exceptions.
class SettingsViewModel {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  SettingsViewModel({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  });

  /// Get user settings from local data source.
  ///
  /// Returns a [Result] containing either the loaded [SettingsEntity]
  /// or an error message.
  Future<Result<SettingsEntity>> getSettings() async {
    return await getSettingsUseCase.call();
  }

  /// Save user settings to local data source.
  ///
  /// Returns a [Result] containing void or an error message.
  Future<Result<void>> saveSettings(SettingsEntity settings) async {
    return await saveSettingsUseCase(settings);
  }
}
