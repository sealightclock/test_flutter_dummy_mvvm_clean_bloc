import 'package:geolocator/geolocator.dart';
import '../../domain/entity/vehicle_status_entity.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';

/// ViewModel responsible for location permission and vehicle status streaming.
///
/// Uses geolocator instead of permission_handler to reliably trigger
/// permission dialogs on both real devices and simulators.
/// !!! "permission_handler.dart" will silently fail on iOS Simulator (The system Location permission dialog won't be triggered!)
class VehicleStatusViewModel {
  final GetVehicleStatusUseCase useCase;

  VehicleStatusViewModel(this.useCase);

  /// Stream of vehicle status (from use case).
  Stream<VehicleStatusEntity> getVehicleStatusStream() {
    return useCase.call();
  }

  /// Checks and requests location permission.
  ///
  /// Return values:
  /// - `true`  => permission granted
  /// - `false` => denied (not permanently)
  /// - `null`  => permanently denied (user must open settings)
  Future<bool?> checkAndRequestLocationPermission() async {
    // Ensure location services are enabled (GPS toggle)
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check current permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // User must manually enable in Settings
      return null;
    }

    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }
}
