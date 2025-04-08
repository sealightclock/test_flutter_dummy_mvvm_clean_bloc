import 'package:hive_flutter/adapters.dart';

import '../../domain/entity/my_string_entity.dart';
import 'my_string_local_data_source.dart';

/// Data source handler to handle local data persistence using Hive.
class MyStringHiveDataSource implements MyStringLocalDataSource {
  // Box
  static const String hiveBoxName = 'my_string_hive_box';
  // Key
  static const String myStringKey = 'my_string_key';

  // Initialization:
  static bool _isInitialized = false;

  /// Ensures Hive is initialized and the box is opened before usage.
  Future<void> _initialize() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      Hive.registerAdapter(MyStringEntityAdapter());
      _isInitialized = true;
    }
  }

  /// Retrieves stored MyStringEntity object or assigns a default value if absent.
  @override
  Future<MyStringEntity> getMyString() async {
    await _initialize(); // Ensure Hive is ready
    final box = await Hive.openBox<MyStringEntity>(hiveBoxName);
    return box.get(myStringKey) ?? MyStringEntity(value: 'Default Value from '
        'Hive');
  }

  /// Stores a MyStringEntity object into Hive Box.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    await _initialize(); // Ensure Hive is ready
    final box = await Hive.openBox<MyStringEntity>(hiveBoxName);
    await box.put(myStringKey, value);
  }
}
