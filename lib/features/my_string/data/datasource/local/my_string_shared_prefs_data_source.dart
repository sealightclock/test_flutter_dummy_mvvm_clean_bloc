import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/util/constants/app_constants.dart';
import '../../../domain/entity/my_string_entity.dart';
import 'my_string_local_data_source.dart';

/// Data source handler to handle local data persistence using SharedPreferences.
///
/// Implements a singleton pattern to avoid repeated getInstance() calls.
class MyStringSharedPrefsDataSource implements MyStringLocalDataSource {
  // Singleton instance of SharedPreferences
  static SharedPreferences? _prefs;

  // Initializes SharedPreferences once to prevent redundant calls.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Retrieves stored value or assigns a default value if absent.
  @override
  Future<MyStringEntity> getMyString() async {
    if (_prefs == null) await init();

    // Read from SharedPreferences or fallback to default
    String? storedValue = _prefs?.getString(AppConstants.myStringKey);

    if (storedValue == null) {
      storedValue = AppConstants.defaultValueSharedPrefs;

      // Store default value to persist it for future loads
      await _prefs?.setString(AppConstants.myStringKey, storedValue);
    }

    return MyStringEntity(value: storedValue);
  }

  /// Stores a string value into SharedPreferences.
  @override
  Future<void> storeMyString(MyStringEntity value) async {
    if (_prefs == null) await init();

    await _prefs?.setString(AppConstants.myStringKey, value.value);
  }
}
