import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entity/user_auth_entity.dart';

/// Repository to handle authentication data persistence using Hive.
class AuthRepository {
  static const String _userBoxName = 'user_auth_box'; // Box name for Hive

  // Initialization:
  static bool _isInitialized = false;

  /// Ensures Hive is initialized and the box is opened before usage.
  Future<void> _initialize() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      // No custom adapter needed for simple Map storage
      _isInitialized = true;
    }
  }

  /// Signs up a new user by storing username, password and logged-in status into Hive.
  Future<void> signUp(String username, String password) async {
    await _initialize(); // Ensure Hive is ready
    final box = await Hive.openBox(_userBoxName);
    final user = UserAuthEntity(username: username, password: password, isLoggedIn: true);
    await box.put('user', user.toMap());
  }

  /// Logs in an existing user by validating credentials.
  Future<void> login(String username, String password) async {
    await _initialize(); // Ensure Hive is ready
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

  /// Allows guest login without requiring username or password.
  Future<void> guestLogin() async {
    await _initialize(); // Ensure Hive is ready
    final box = await Hive.openBox(_userBoxName);
    final guestUser = UserAuthEntity(username: 'Guest', password: '', isLoggedIn: true);
    await box.put('user', guestUser.toMap());
  }

  /// Retrieves current user authentication status from Hive.
  Future<UserAuthEntity?> getUserAuthStatus() async {
    await _initialize(); // Ensure Hive is ready
    final box = await Hive.openBox(_userBoxName);
    final userMap = box.get('user');

    if (userMap == null) return null;

    return UserAuthEntity.fromMap(Map<String, dynamic>.from(userMap));
  }
}
