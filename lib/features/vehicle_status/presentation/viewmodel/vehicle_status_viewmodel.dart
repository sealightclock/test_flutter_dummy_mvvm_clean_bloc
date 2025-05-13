import '../../../../app/core/permission/permission_manager.dart';
import '../../domain/entity/vehicle_status_entity.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';

/// ViewModel responsible for location permission and vehicle status streaming.
///
/// PermissionManager is injected to handle platform-specific location permissions.
/// This keeps permission logic centralized and testable.
class VehicleStatusViewModel {
  final GetVehicleStatusUseCase getVehicleStatusUseCase;
  final PermissionManager permissionManager;

  VehicleStatusViewModel({
    required this.getVehicleStatusUseCase,
    required this.permissionManager,
  });

  /// Returns a continuous stream of vehicle location and speed from the domain layer.
  Stream<VehicleStatusEntity> getVehicleStatusStream() {
    return getVehicleStatusUseCase.call();
  }

  /// Checks and requests location permission using centralized manager.
  ///
  /// Return values:
  /// - `true`  => permission granted
  /// - `false` => denied (user might try again later)
  /// - `null`  => permanently denied (user must open settings)
  Future<bool?> checkAndRequestLocationPermission() async {
    final granted = await permissionManager.checkAndRequest([AppPermission.location]);

    if (granted) return true;

    // For simplicity, we treat all denied cases the same.
    // If needed, platform-specific 'permanentlyDenied' logic can be added later.
    return false;
  }
}
