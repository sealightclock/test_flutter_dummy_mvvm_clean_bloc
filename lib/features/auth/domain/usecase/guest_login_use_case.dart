import '../../../../util/result.dart';
import '../../data/repository/auth_repository.dart';

class GuestLoginUseCase {
  final AuthRepository repository;

  GuestLoginUseCase(this.repository);

  Future<Result<void>> execute() async {
    return repository.guestLogin();
  }
}
