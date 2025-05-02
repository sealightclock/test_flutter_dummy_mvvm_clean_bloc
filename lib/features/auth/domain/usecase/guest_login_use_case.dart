import '../../../../util/result.dart';
import '../../data/repository/auth_repository.dart';

class GuestLoginUseCase {
  final AuthRepository repository;

  GuestLoginUseCase({required this.repository});

  Future<Result<void>> call() async {
    try {
      await repository.guestLogin();
      return const Success(null);
    } catch (e) {
      return Failure('Failed to guestLogin: \$e');
    }
  }
}
