import 'package:hive/hive.dart';
import '../../domain/entity/user_auth_entity.dart';

class AuthRepository {
  static const String _userBoxName = 'userAuthBox';

  Future<void> signUp(String username, String password) async {
    final box = await Hive.openBox(_userBoxName);
    final user = UserAuthEntity(username: username, password: password, isLoggedIn: true);
    await box.put('user', user.toMap());
  }

  Future<void> login(String username, String password) async {
    final box = await Hive.openBox(_userBoxName);
    final userMap = box.get('user');

    if (userMap == null) {
      throw Exception('User not found. Please sign up first.');
    }

    final storedUser = UserAuthEntity.fromMap(Map<String, dynamic>.from(userMap));
    if (storedUser.username == username && storedUser.password == password) {
      final updatedUser = UserAuthEntity(username: username, password: password, isLoggedIn: true);
      await box.put('user', updatedUser.toMap());
    } else {
      throw Exception('Invalid username or password.');
    }
  }

  Future<void> guestLogin() async {
    final box = await Hive.openBox(_userBoxName);
    final guestUser = UserAuthEntity(username: 'Guest', password: '', isLoggedIn: true);
    await box.put('user', guestUser.toMap());
  }

  Future<UserAuthEntity?> getUserAuthStatus() async {
    final box = await Hive.openBox(_userBoxName);
    final userMap = box.get('user');

    if (userMap == null) return null;

    return UserAuthEntity.fromMap(Map<String, dynamic>.from(userMap));
  }
}
