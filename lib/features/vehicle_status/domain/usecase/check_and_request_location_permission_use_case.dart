import '../../data/repository/vehicle_status_repository.dart';

class CheckAndRequestLocationPermissionUseCase {
  late final VehicleStatusRepository repository;

  CheckAndRequestLocationPermissionUseCase({required this.repository});

  Future<bool?> checkAndRequestLocationPermission() {
    return repository.checkAndRequestLocationPermission();
  }
}