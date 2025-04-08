class UserAuthEntity {
  final String username;
  final String password;
  final bool isLoggedIn;

  UserAuthEntity({
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
  factory UserAuthEntity.fromMap(Map<String, dynamic> map) {
    return UserAuthEntity(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      isLoggedIn: map['isLoggedIn'] ?? false,
    );
  }
}
