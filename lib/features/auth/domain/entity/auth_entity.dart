import 'package:hive/hive.dart';

part 'auth_entity.g.dart';

@HiveType(typeId: 2)
class AuthEntity {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final bool isLoggedIn;

  const AuthEntity({
    required this.username,
    required this.password,
    required this.isLoggedIn,
  });
}
