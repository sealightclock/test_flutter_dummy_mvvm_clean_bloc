import 'package:permission_handler/permission_handler.dart';

import '../../domain/entity/vehicle_status_entity.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';

/// ViewModel responsible for interacting with the UseCase and checking location permissions.
///
/// Now uses 'permission_handler' package to request and verify permissions explicitly,
/// matching the BLE feature style.
class VehicleStatusViewModel {
  final GetVehicleStatusUseCase _useCase;

  VehicleStatusViewModel() : _useCase = GetVehicleStatusUseCase();

  Stream<VehicleStatusEntity> get vehicleStatusStream => _useCase();

  /// Requests location permission and checks if granted.
  ///
  /// Steps:
  /// 1. Request location permission from the user.
  /// 2. Check if the permission is granted.
  /// 3. If denied or permanently denied, return false.
  Future<bool> checkAndRequestLocationPermission() async {
    final permissionStatus = await Permission.location.status;

    if (permissionStatus.isGranted) {
      return true; // Already granted.
    }

    // If denied, request permission.
    final newStatus = await Permission.location.request();

    // Return true only if now granted.
    return newStatus.isGranted;
  }
}
