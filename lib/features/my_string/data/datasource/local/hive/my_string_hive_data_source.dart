import '../../../../../../shared/constants/app_constants.dart';
import '../../../../../shared_feature/hive_utils.dart';
import 'my_string_hive_dto.dart';

/// Specialized Hive-only local data source that avoids using domain entities.
///
/// This source works only with [MyStringHiveDto] objects.
/// Conversion to/from [MyStringEntity] is handled in the Repository layer.
class MyStringHiveDataSource {
  /// Retrieves stored Hive DTO or returns null if not set.
  Future<MyStringHiveDto?> getMyStringDto() async {
    final box = await HiveUtils.openBox<MyStringHiveDto>(AppConstants.myStringHiveBoxName);
    return box.get(AppConstants.myStringKey);
  }

  /// Stores a Hive DTO into the Hive box.
  Future<void> storeMyStringDto(MyStringHiveDto dto) async {
    final box = await HiveUtils.openBox<MyStringHiveDto>(AppConstants.myStringHiveBoxName);
    await box.put(AppConstants.myStringKey, dto);
  }
}
