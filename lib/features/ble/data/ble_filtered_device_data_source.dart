import 'dart:typed_data';

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
      final lower = name.toLowerCase();

      final isLikelyPhoneOrWatch = lower.contains("phone") ||
          lower.contains("watch") ||
          lower.contains("galaxy") ||
          lower.contains("samsung") ||
          lower.contains("pixel") ||
          lower.contains("moto") ||
          lower.contains("xiaomi") ||
          lower.contains("oneplus") ||
          lower.contains("oppo") ||
          lower.contains("iphone") ||
          lower.contains("ipad") ||
          lower.contains("iwatch");

      // Extract manufacturer ID and data
      int? manufacturerId;
      String? manufacturerHex;

      if (device.manufacturerData.isNotEmpty && device.manufacturerData.length >= 2) {
        final bytes = device.manufacturerData;
        final byteData = ByteData.sublistView(bytes);
        manufacturerId = byteData.getUint16(0, Endian.little); // first 2 bytes
        manufacturerHex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase();
      }

      if (showAll || isLikelyPhoneOrWatch) {
        foundDevices[id] = BleDeviceEntity(
          id: device.id,
          name: name,
          rssi: device.rssi,
          manufacturerId: manufacturerId,
          manufacturerHex: manufacturerHex,
        );
      }

      final sorted = foundDevices.values.toList()
        ..sort((a, b) => b.rssi.compareTo(a.rssi)); // strongest first

      return sorted;
    });
  }

  @override
  Stream<ConnectionStateUpdate> connect(String deviceId) {
    return _ble.connectToDevice(id: deviceId);
  }
}
