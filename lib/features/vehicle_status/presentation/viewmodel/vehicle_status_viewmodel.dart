import '../../domain/entity/vehicle_status_entity.dart';
import '../../domain/usecase/check_and_request_location_permission_use_case.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';

/// ViewModel responsible for location permission and vehicle status streaming.
///
/// Uses geolocator instead of permission_handler to reliably trigger
/// permission dialogs on both real devices and simulators.
/// !!! "permission_handler.dart" will silently fail on iOS Simulator (The system Location permission dialog won't be triggered!)
class VehicleStatusViewModel {
  final GetVehicleStatusUseCase getVehicleStatusUseCase;
  final CheckAndRequestLocationPermissionUseCase checkAndRequestLocationPermissionUseCase;

  VehicleStatusViewModel({
    required this.getVehicleStatusUseCase,
    required this.checkAndRequestLocationPermissionUseCase,
  });

  /// Stream of vehicle status (from use case).
  Stream<VehicleStatusEntity> getVehicleStatusStream() {
    return getVehicleStatusUseCase.call();
  }

  /// Checks and requests location permission.
  ///
  /// Return values:
  /// - `true`  => permission granted
  /// - `false` => denied (not permanently)
  /// - `null`  => permanently denied (user must open settings)
  Future<bool?> checkAndRequestLocationPermission() async {
    return await getVehicleStatusUseCase.repository.checkAndRequestLocationPermission();
  }
}
