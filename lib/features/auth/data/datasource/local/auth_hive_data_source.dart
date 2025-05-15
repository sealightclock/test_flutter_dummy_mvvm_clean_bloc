import '../../../../../shared/util/constants/app_constants.dart';
import '../../../../../shared/util/hive/hive_utils.dart';
import '../../../domain/entity/auth_entity.dart';

/// Data source handler to manage authentication locally using Hive.
class AuthHiveDataSource {
  /// Store user data after signup or login.
  Future<void> storeAuth(AuthEntity auth) async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.put(AppConstants.authKey, auth);
  }

  /// Retrieve user data if exists.
  Future<AuthEntity> getAuth() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    return box.get(AppConstants.authKey) ??
        AuthEntity(username: '', password: '', isLoggedIn: false);
  }

  /// Clear stored user data after logout.
  Future<void> clearAuth() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.delete(AppConstants.authKey);
  }
}
