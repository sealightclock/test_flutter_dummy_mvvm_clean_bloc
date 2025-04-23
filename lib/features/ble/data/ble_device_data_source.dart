import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import '../domain/entity/ble_device_entity.dart';
import 'ble_device_repository.dart';

class BleDeviceDataSource implements BleDeviceRepository {
  final FlutterReactiveBle _ble;

  BleDeviceDataSource(this._ble);

  @override
  Stream<List<BleDeviceEntity>> scanDevices() async* {
    // Request permissions first
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    final devices = <String, BleDeviceEntity>{};

    yield* _ble.scanForDevices(withServices: []).map((device) {
      devices[device.id] = BleDeviceEntity(id: device.id, name: device.name);
      return devices.values.toList();
    });
  }

  @override
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return _ble.connectToDevice(id: deviceId);
  }
}
