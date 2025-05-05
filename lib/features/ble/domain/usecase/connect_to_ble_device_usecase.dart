import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../data/repository/ble_device_repository.dart';

class ConnectToBleDeviceUseCase {
  final BleDeviceRepository repository;

  ConnectToBleDeviceUseCase({required this.repository});

  // Do not wrap Stream into Result<T>, as it has its own error handling mechanism.
  Stream<ConnectionStateUpdate> call(String deviceId) {
    return repository.connect(deviceId);
  }
}
