import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../domain/entity/ble_device_entity.dart';
import 'ble_device_repository.dart';

class BleDeviceDataSource implements BleDeviceRepository {
  final FlutterReactiveBle _ble;

  BleDeviceDataSource(this._ble);

  @override
  Stream<List<BleDeviceEntity>> scanDevices() {
    return _ble.scanForDevices(withServices: []).map((device) {
      return [BleDeviceEntity(id: device.id, name: device.name)];
    });
  }

  @override
  Future<void> connectToDevice(String id) async {
    await _ble.connectToDevice(id: id).first;
  }
}
