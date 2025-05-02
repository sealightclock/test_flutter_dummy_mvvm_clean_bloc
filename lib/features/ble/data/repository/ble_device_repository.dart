import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../domain/entity/ble_device_entity.dart';

abstract class BleDeviceRepository {
  Stream<List<BleDeviceEntity>> scanDevices({required bool showAll});
  Stream<ConnectionStateUpdate> connect(String deviceId);
}
