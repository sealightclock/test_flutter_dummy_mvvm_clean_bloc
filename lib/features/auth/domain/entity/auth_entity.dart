import 'package:hive/hive.dart';

part 'auth_entity.g.dart';

@HiveType(typeId: 2)
class AuthEntity {
  @HiveField(0)
  late final String username;

  @HiveField(1)
  late final String password;

  @HiveField(2)
  late final bool isLoggedIn;

  AuthEntity(this.username, this.password, this.isLoggedIn);
}
