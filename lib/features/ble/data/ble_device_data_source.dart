import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../domain/entity/ble_device_entity.dart';

class BleDeviceDataSource {
  final FlutterReactiveBle _ble;
  BleDeviceDataSource(this._ble);

  @protected
  FlutterReactiveBle get ble => _ble;

  Stream<List<BleDeviceEntity>> scanDevices() {
    // Default implementation (can be overridden)
    return const Stream.empty();
  }

  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return _ble.connectToDevice(id: deviceId);
  }
}
