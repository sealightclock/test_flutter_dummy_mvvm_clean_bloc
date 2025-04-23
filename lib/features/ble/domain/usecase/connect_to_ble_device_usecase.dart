// connect_to_ble_device_usecase.dart
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../data/ble_device_repository.dart';

class ConnectToBleDeviceUseCase {
  final BleDeviceRepository repository;

  ConnectToBleDeviceUseCase(this.repository);

  Stream<ConnectionStateUpdate> connect(String deviceId) {
    return repository.connectToDevice(deviceId); // must return Stream
  }
}
