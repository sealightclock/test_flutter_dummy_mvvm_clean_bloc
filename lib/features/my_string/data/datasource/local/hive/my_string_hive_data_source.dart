import '../../../../../../shared/constants/app_constants.dart';
import '../../../../../shared_feature/hive_utils.dart';
import '../../../../domain/entity/my_string_entity.dart';
import '../my_string_local_data_source.dart';
import 'my_string_hive_dto.dart';

/// Data source handler to handle local data persistence using Hive.
class MyStringHiveDataSource implements MyStringLocalDataSource {
  /// Retrieves stored MyStringEntity object or assigns a default value if absent.
  @override
  Future<MyStringEntity> getMyString() async {
    final box = await HiveUtils.openBox<MyStringHiveDto>(AppConstants.myStringHiveBoxName);

    final defaultVal = MyStringEntity(value: AppConstants.defaultValueHive);
    final storedVal = box.get(AppConstants.myStringKey);
    if (storedVal == null) {
      return defaultVal;
    } else {
      return storedVal.toEntity();
    }
  }

  /// Stores a MyStringEntity object into Hive Box.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    final box = await HiveUtils.openBox<MyStringHiveDto>(AppConstants.myStringHiveBoxName);
    final val = MyStringHiveDto(value: value.value);
    await box.put(AppConstants.myStringKey, val);
  }
}
