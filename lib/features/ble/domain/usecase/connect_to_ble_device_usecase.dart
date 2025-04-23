import '../../data/ble_device_repository.dart';

/// Use case that connects to a BLE device by its ID.
/// Assumes device scan has already been performed and device is available.
class ConnectToBleDeviceUseCase {
  final BleDeviceRepository repository;

  ConnectToBleDeviceUseCase(this.repository);

  Future<void> execute(String deviceId) async {
    await repository.connectToDevice(deviceId);
  }
}
