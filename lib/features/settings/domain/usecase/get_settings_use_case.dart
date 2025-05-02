import '../../../../util/result.dart';
import '../entity/settings_entity.dart';
import '../../data/repository/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase({required this.repository});

  Future<Result<SettingsEntity>> call() async {
    try {
      final settings = await repository.getSettings();
      return Success(settings);
    } catch (e) {
      return Failure('Failed to load settings: \$e');
    }
  }
}
