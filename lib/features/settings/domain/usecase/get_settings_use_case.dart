import '../../../../core/result/result.dart';
import '../../data/repository/settings_repository.dart';
import '../entity/settings_entity.dart';

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
