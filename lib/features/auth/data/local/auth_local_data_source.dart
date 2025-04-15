import '../../../../../util/hive_utils.dart';
import '../../domain/entity/user_auth_entity.dart';

/// Data source handler to manage authentication locally using Hive.
class AuthLocalDataSource {
  static const String _userBoxName = 'user_auth_box';

  /// Store user data after signup or login.
  Future<void> storeUser(UserAuthEntity user) async {
    final box = await HiveUtils.openBox(_userBoxName);
    await box.put('user', user.toMap());
  }

  /// Retrieve user data if exists.
  Future<UserAuthEntity?> getUser() async {
    final box = await HiveUtils.openBox(_userBoxName);
    final userMap = box.get('user');
    if (userMap == null) return null;
    return UserAuthEntity.fromMap(Map<String, dynamic>.from(userMap));
  }

  /// Clear stored user data after logout.
  Future<void> clearUser() async {
    final box = await HiveUtils.openBox(_userBoxName);
    await box.delete('user');
  }
}
