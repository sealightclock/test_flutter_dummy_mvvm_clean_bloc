import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../domain/entity/ble_device_entity.dart';
import 'ble_device_data_source.dart';
import 'ble_device_repository.dart';

class BleFilteredDeviceDataSource extends BleDeviceDataSource
    implements BleDeviceRepository {
  BleFilteredDeviceDataSource(super.ble);

  @override
  Stream<List<BleDeviceEntity>> scanDevices() {
    final devices = <String, BleDeviceEntity>{};

    return ble.scanForDevices(withServices: []).map((device) {
      final name = device.name.trim().toLowerCase();

      // Log every scanned device
      //debugPrint("BLE found: ${device.name} (${device.id})");

      final isLikelyPhoneOrWatch =
          name.contains("iphone") ||
              name.contains("android") ||
              name.contains("watch") ||
              name.contains("pixel") ||
              name.contains("galaxy") ||
              name.contains("samsung") ||
              name.contains("oneplus");

      final isNotEmpty = name.isNotEmpty;

      // Keep named devices that match, or unnamed ones if you want to debug
      if (isLikelyPhoneOrWatch || !isNotEmpty) {
        devices[device.id] = BleDeviceEntity(id: device.id, name: device.name);
      }

      return devices.values.toList();
    });
  }

  @override
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return ble.connectToDevice(id: deviceId);
  }
}
