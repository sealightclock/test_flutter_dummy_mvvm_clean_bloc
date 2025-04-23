import '../domain/entity/ble_device_entity.dart';

abstract class BleDeviceRepository {
  Stream<List<BleDeviceEntity>> scanDevices();
  Future<void> connectToDevice(String id);
}
