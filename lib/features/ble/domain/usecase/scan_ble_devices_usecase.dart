import '../entity/ble_device_entity.dart';
import '../../data/ble_device_repository.dart';

class ScanBleDevicesUseCase {
  final BleDeviceRepository repository;

  ScanBleDevicesUseCase(this.repository);

  Stream<List<BleDeviceEntity>> execute({required bool showAll}) {
    return repository.scanDevices(showAll: showAll);
  }
}
