import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/domain/entity/my_string_entity.dart';

import 'my_string_local_data_source.dart';

/// Data source handler to handle local data persistence using
/// SharedPreferences.
/// Implements a singleton pattern to avoid repeated `getInstance()` calls.
class MyStringSharedPrefsDataSource implements MyStringLocalDataSource {
  // Key
  static const String myStringKey = 'my_string_key';

  // Initialization
  static SharedPreferences? _prefs;
  // Initializes SharedPreferences once to prevent redundant calls.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Retrieves stored value or assigns a default value if absent.
  @override
  Future<MyStringEntity> getMyString() async {
    if (_prefs == null) await init();

    String? storedValue = _prefs?.getString(myStringKey);

    if (storedValue == null) {
      storedValue = 'Default Value from SharedPreferences'; // Ensure a valid default value.
      await _prefs?.setString(myStringKey, storedValue); // Store default value once.
    }

    return MyStringEntity(storedValue);
  }

  /// Stores a string value into SharedPreferences.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    if (_prefs == null) await init();

    await _prefs?.setString(myStringKey, value.value);
  }
}
