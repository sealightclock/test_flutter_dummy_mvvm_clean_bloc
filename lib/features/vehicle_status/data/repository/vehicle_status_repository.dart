import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entity/vehicle_status_entity.dart';
import '../datasource/platform/vehicle_status_data_source.dart';

/// Repository responsible for providing a throttled [Stream] of [VehicleStatusEntity].
class VehicleStatusRepository {
  late final VehicleStatusDataSource dataSource;

  VehicleStatusRepository(
      {required this.dataSource}
  );

  /// Returns a [Stream] of [VehicleStatusEntity] throttled to 1 event per second.
  Stream<VehicleStatusEntity> getVehicleStatusStream() {
    return dataSource.getPositionStreamRaw()
        .throttleTime(const Duration(seconds: 1))
        .map((position) {
      // TODO: Consider using CAN bus speed for better accuracy.
      final speedKmh = (position.speed) * 3.6; // Convert m/s to km/h

      return VehicleStatusEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        speedKmh: speedKmh,
      );
    });
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
