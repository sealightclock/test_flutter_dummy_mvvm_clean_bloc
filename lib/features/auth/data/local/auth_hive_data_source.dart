import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity'
    '/auth_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/app_constants.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/hive_utils.dart';

/// Data source handler to manage authentication locally using Hive.
class AuthHiveDataSource {
  /// Store user data after signup or login.
  Future<void> storeAuth(AuthEntity auth) async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.put(AppConstants.authKey, auth);
  }

  /// Retrieve user data if exists.
  Future<AuthEntity?> getAuth() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    final auth = box.get(AppConstants.authKey);
    if (auth == null) return null;
    return auth;
  }

  /// Clear stored user data after logout.
  Future<void> clearAuth() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.delete(AppConstants.authKey);
  }
}
