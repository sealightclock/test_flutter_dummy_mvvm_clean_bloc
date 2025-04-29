import 'package:geolocator/geolocator.dart';

import '../../domain/entity/vehicle_status_entity.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';

/// ViewModel responsible for interacting with the UseCase and checking permissions.
class VehicleStatusViewModel {
  final GetVehicleStatusUseCase _useCase;

  VehicleStatusViewModel() : _useCase = GetVehicleStatusUseCase();

  Stream<VehicleStatusEntity> get vehicleStatusStream => _useCase();

  /// Check and request location permission.
  Future<bool> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }
}
