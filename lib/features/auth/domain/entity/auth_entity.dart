class AuthEntity {
  final String username;
  final String password;
  final bool isLoggedIn;

  AuthEntity({
    required this.username,
    required this.password,
    required this.isLoggedIn,
  });

  // Convert to Map for Hive
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'isLoggedIn': isLoggedIn,
    };
  }

  // Create from Map
  factory AuthEntity.fromMap(Map<String, dynamic> map) {
    return AuthEntity(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      isLoggedIn: map['isLoggedIn'] ?? false,
    );
  }
}
