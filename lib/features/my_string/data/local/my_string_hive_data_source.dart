import '../../../../../util/app_constants.dart';
import '../../../../../util/hive_utils.dart';
import '../../domain/entity/my_string_entity.dart';
import 'my_string_local_data_source.dart';

/// Data source handler to handle local data persistence using Hive.
class MyStringHiveDataSource implements MyStringLocalDataSource {
  /// Retrieves stored MyStringEntity object or assigns a default value if absent.
  @override
  Future<MyStringEntity> getMyString() async {
    final box = await HiveUtils.openBox<MyStringEntity>(AppConstants.myStringHiveBoxName);

    // ✅ Return stored value or fallback to default (centralized constant)
    return box.get(AppConstants.myStringKey) ??
        MyStringEntity(value: AppConstants.defaultValueHive);
  }

  /// Stores a MyStringEntity object into Hive Box.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    final box = await HiveUtils.openBox<MyStringEntity>(AppConstants.myStringHiveBoxName);
    await box.put(AppConstants.myStringKey, value);
  }
}
