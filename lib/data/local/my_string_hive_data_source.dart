import 'package:hive_flutter/adapters.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';

import 'my_string_local_data_source.dart';

/// Data source handler to handle local data persistence using Hive.
class MyStringHiveDataSource implements MyStringLocalDataSource {
  //  Box
  static const String hiveBoxName = 'my_string_hive_box';
  //  Key
  static const String myStringKey = 'my_string_key';

  //  Initialization:
  static bool _isInitialized = false;
  static Box<String>? _box;

  /// Ensures Hive is initialized and the box is opened before usage.
  Future<void> _initialize() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      _box = await Hive.openBox<String>(hiveBoxName);
      _isInitialized = true;
    }
  }

  /// Retrieves stored string value or assigns a default value if absent.
  @override
  Future<MyStringEntity> getMyString() async {
    await _initialize(); // Ensure Hive is ready
    var value = _box?.get(myStringKey, defaultValue: 'Default Value from Hive') ?? "Default Value from Hive";
    return MyStringEntity(value);
  }

  /// Stores a string value into Hive Box.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    await _initialize(); // Ensure Hive is ready
    await _box?.put(myStringKey, value.value);
  }
}
