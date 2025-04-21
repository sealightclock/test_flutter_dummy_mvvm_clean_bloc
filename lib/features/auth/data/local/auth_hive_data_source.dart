import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity'
    '/auth_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/app_constants.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/hive_utils.dart';

/// Data source handler to manage authentication locally using Hive.
class AuthHiveDataSource {
  /// Store user data after signup or login.
  Future<void> storeUser(AuthEntity user) async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.put(AppConstants.authKey, user);
  }

  /// Retrieve user data if exists.
  Future<AuthEntity?> getUser() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    final user = box.get(AppConstants.authKey);
    if (user == null) return null;
    return user;
  }

  /// Clear stored user data after logout.
  Future<void> clearUser() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.delete(AppConstants.authKey);
  }
}
