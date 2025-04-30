import 'package:rxdart/rxdart.dart';

import '../../domain/entity/vehicle_status_entity.dart';
import '../datasource/vehicle_status_data_source.dart';

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
}
