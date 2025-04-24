import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../domain/entity/ble_device_entity.dart';
import 'ble_device_repository.dart';

import 'package:logger/logger.dart' as my_logger;

final logger = my_logger.Logger();

const phoneWatchManufacturerIds = {
  0x004C, // Apple, Inc.
  0x000F, // Cambridge Silicon Radio (CSR), now Qualcomm
  0x0006, // Microsoft
  0x0075, // Samsung Electronics Co. Ltd.
  0x00E0, // Google
  0x015D, // Xiaomi Inc.
  0x0131, // Huawei Technologies Co. Ltd.
  0x0174, // OnePlus
  0x017C, // Oppo
  0x0171, // Realtek Semiconductor
  0x0152, // Motorola
};

class BleDeviceDataSource implements BleDeviceRepository {
  final FlutterReactiveBle _ble;

  BleDeviceDataSource(this._ble);

  @override
  Stream<List<BleDeviceEntity>> scanDevices({required bool showAll}) {
    final foundDevices = <String, BleDeviceEntity>{};

    return _ble.scanForDevices(withServices: []).map((device) {
      final id = device.id.toUpperCase();
      final name = device.name.trim().isEmpty ? "Unknown Device" : device.name.trim();
      final lower = name.toLowerCase();
      
      logger.t('TFDB: BleFilteredDeviceDataSource: scanDevices: name=[$name]');

      // Extract manufacturer ID and data
      int? manufacturerId;
      String? manufacturerHex;

      if (device.manufacturerData.isNotEmpty && device.manufacturerData.length >= 2) {
        final bytes = device.manufacturerData;
        final byteData = ByteData.sublistView(bytes);
        manufacturerId = byteData.getUint16(0, Endian.little); // first 2 bytes
        manufacturerHex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase();
      }

      // TODO: This algorithm is not accurate.
      //   1. Without the last line, it returns false most of the time.
      //   2. With the last line, it returns true most opf the time.
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
          lower.contains("iwatch") ||
          (manufacturerId != null && phoneWatchManufacturerIds.contains(manufacturerId));


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
