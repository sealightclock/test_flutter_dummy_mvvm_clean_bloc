import '../../data/repository/auth_repository.dart';

class GuestLoginUseCase {
  final AuthRepository repository;

  GuestLoginUseCase(this.repository);

  Future<void> call() async {
    await repository.guestLogin();
  }
}
