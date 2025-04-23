import '../entity/ble_device_entity.dart';
import '../../data/ble_device_repository.dart';

class ScanBleDevicesUseCase {
  final BleDeviceRepository repository;

  ScanBleDevicesUseCase(this.repository);

  Stream<List<BleDeviceEntity>> execute() {
    return repository.scanDevices();
  }
}
