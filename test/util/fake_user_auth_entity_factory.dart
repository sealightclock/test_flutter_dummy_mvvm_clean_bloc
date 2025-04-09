import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/entity/user_auth_entity.dart';

class FakeUserAuthEntityFactory {
  static UserAuthEntity guest() {
    return UserAuthEntity(
      username: '',
      isLoggedIn: false,
      password: '',
    );
  }

  static UserAuthEntity loggedInUser({
    String username = 'test_user',
    String password = 'password',
  }) {
    return UserAuthEntity(
      username: username,
      isLoggedIn: true,
      password: password,
    );
  }
}
