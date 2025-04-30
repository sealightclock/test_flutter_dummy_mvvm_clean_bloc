import 'package:permission_handler/permission_handler.dart';

import '../../domain/entity/vehicle_status_entity.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';

/// ViewModel responsible for interacting with the UseCase and checking location permissions.
///
/// This ViewModel no longer creates its own UseCase instance.
/// Instead, it accepts the UseCase as a constructor parameter,
/// which improves testability and follows Clean Architecture.
class VehicleStatusViewModel {
  final GetVehicleStatusUseCase useCase;

  /// Constructor that receives [GetVehicleStatusUseCase].
  VehicleStatusViewModel(this.useCase);

  /// Exposes a stream of [VehicleStatusEntity] from the use case.
  Stream<VehicleStatusEntity> get vehicleStatusStream => useCase();

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
