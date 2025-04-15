import 'package:hive_flutter/hive_flutter.dart';

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
    // ✅ Register adapter once if not yet done
    if (!Hive.isAdapterRegistered(MyStringEntityAdapter().typeId)) {
      Hive.registerAdapter(MyStringEntityAdapter());
    }

    final box = await HiveUtils.openBox<MyStringEntity>(hiveBoxName);
    return box.get(myStringKey) ?? MyStringEntity(value: 'Default Value from Hive');
  }

  /// Stores a MyStringEntity object into Hive Box.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    if (!Hive.isAdapterRegistered(MyStringEntityAdapter().typeId)) {
      Hive.registerAdapter(MyStringEntityAdapter());
    }

    final box = await HiveUtils.openBox<MyStringEntity>(hiveBoxName);
    await box.put(myStringKey, value);
  }
}
