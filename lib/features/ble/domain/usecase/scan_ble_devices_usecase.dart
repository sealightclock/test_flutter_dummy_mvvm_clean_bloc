import '../entity/ble_device_entity.dart';
import '../../data/repository/ble_device_repository.dart';

class ScanBleDevicesUseCase {
  final BleDeviceRepository repository;

  ScanBleDevicesUseCase({required this.repository});

  // Do not wrap Stream into Result<T>, as it has its own error handling mechanism.
  Stream<List<BleDeviceEntity>> call({required bool showAll}) {
    return repository.scanDevices(showAll: showAll);
  }
}
