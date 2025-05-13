import '../../../../app/util/result/result.dart';
import '../../data/repository/settings_repository.dart';
import '../entity/settings_entity.dart';

class SaveSettingsUseCase {
  final SettingsRepository repository;

  SaveSettingsUseCase({required this.repository});

  Future<Result<void>> call(SettingsEntity settings) async {
    try {
      await repository.saveSettings(settings);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to save settings: \$e');
    }
  }
}
