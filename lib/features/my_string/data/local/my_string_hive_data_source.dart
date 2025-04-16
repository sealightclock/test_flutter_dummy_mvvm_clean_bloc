import '../../../../../util/app_constants.dart'; // ✅ Added import for constants
import '../../../../../util/hive_utils.dart';
import '../../domain/entity/my_string_entity.dart';
import 'my_string_local_data_source.dart';

/// Data source handler to handle local data persistence using Hive.
class MyStringHiveDataSource implements MyStringLocalDataSource {
  // Box and Key definitions
  static const String hiveBoxName = 'my_string_hive_box';
  static const String myStringKey = 'my_string_key';

  /// Retrieves stored MyStringEntity object or assigns a default value if absent.
  @override
  Future<MyStringEntity> getMyString() async {
    final box = await HiveUtils.openBox<MyStringEntity>(hiveBoxName);

    // ✅ Return stored value or fallback to default (centralized constant)
    return box.get(myStringKey) ??
        MyStringEntity(value: AppConstants.defaultValueHive);
  }

  /// Stores a MyStringEntity object into Hive Box.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    final box = await HiveUtils.openBox<MyStringEntity>(hiveBoxName);
    await box.put(myStringKey, value);
  }
}
