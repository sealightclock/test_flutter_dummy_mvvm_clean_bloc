import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entity/user_auth_entity.dart';

/// Data source handler to manage authentication locally using Hive.
class AuthLocalDataSource {
  static const String _userBoxName = 'user_auth_box';

  static bool _isInitialized = false;

  /// Ensures Hive is initialized before any operation.
  Future<void> _initialize() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      _isInitialized = true;
    }
  }

  /// Store user data after signup or login.
  Future<void> storeUser(UserAuthEntity user) async {
    await _initialize();
    final box = await Hive.openBox(_userBoxName);
    await box.put('user', user.toMap());
  }

  /// Retrieve user data if exists.
  Future<UserAuthEntity?> getUser() async {
    await _initialize();
    final box = await Hive.openBox(_userBoxName);
    final userMap = box.get('user');
    if (userMap == null) return null;
    return UserAuthEntity.fromMap(Map<String, dynamic>.from(userMap));
  }

  /// Clear stored user data after logout.
  Future<void> clearUser() async {
    await _initialize();
    final box = await Hive.openBox(_userBoxName);
    await box.delete('user');
  }
}
