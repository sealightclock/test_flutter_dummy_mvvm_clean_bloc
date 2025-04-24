import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../domain/entity/ble_device_entity.dart';
import 'ble_device_repository.dart';

class BleFilteredDeviceDataSource implements BleDeviceRepository {
  final FlutterReactiveBle _ble;

  BleFilteredDeviceDataSource(this._ble);

  @override
  Stream<List<BleDeviceEntity>> scanDevices({required bool showAll}) {
    final foundDevices = <String, BleDeviceEntity>{};

    return _ble.scanForDevices(withServices: []).map((device) {
      final id = device.id.toUpperCase();
      final name = device.name.trim().isEmpty ? "Unknown Device" : device.name.trim();

      if (!showAll) {
        final lower = name.toLowerCase();
        final isLikelyPhoneOrWatch = lower.contains("phone") || lower.contains("watch")
            || lower.contains("iphone") || lower.contains("samsung") || lower.contains("galaxy");
        if (!isLikelyPhoneOrWatch) return foundDevices.values.toList(); // skip this device
      }

      foundDevices[id] = BleDeviceEntity(
        id: id,
        name: name,
        rssi: device.rssi,
      );

      final sorted = foundDevices.values.toList()
        ..sort((a, b) => b.rssi.compareTo(a.rssi));

      return sorted;
    });
  }

  @override
  Stream<ConnectionStateUpdate> connect(String deviceId) {
    return _ble.connectToDevice(id: deviceId);
  }
}
