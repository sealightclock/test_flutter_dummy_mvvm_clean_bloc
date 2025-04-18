import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity'
    '/user_auth_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/app_constants.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/hive_utils.dart';

/// Data source handler to manage authentication locally using Hive.
class AuthHiveDataSource {
  /// Store user data after signup or login.
  Future<void> storeUser(UserAuthEntity user) async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.put(AppConstants.authKey, user.toMap());
  }

  /// Retrieve user data if exists.
  Future<UserAuthEntity?> getUser() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    final userMap = box.get(AppConstants.authKey);
    if (userMap == null) return null;
    return UserAuthEntity.fromMap(Map<String, dynamic>.from(userMap));
  }

  /// Clear stored user data after logout.
  Future<void> clearUser() async {
    final box = await HiveUtils.openBox(AppConstants.authHiveBoxName);
    await box.delete(AppConstants.authKey);
  }
}
