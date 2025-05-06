import 'dart:typed_data';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../domain/entity/ble_device_entity.dart';
import '../repository/ble_device_repository.dart';
import 'package:logger/logger.dart' as my_logger;
import 'ble_device_filter_utils.dart';

final logger = my_logger.Logger();

class BleDeviceDataSource implements BleDeviceRepository {
  final FlutterReactiveBle _ble;

  BleDeviceDataSource(this._ble);

  @override
  Stream<List<BleDeviceEntity>> scanDevices({required bool showAll}) async* {
    final foundDevices = <String, BleDeviceEntity>{};

    await for (final device in _ble.scanForDevices(withServices: [])) {
      final id = device.id.toUpperCase();
      final name = device.name.trim().isEmpty ? "Unknown Device" : device.name.trim();

      int? manufacturerId;
      String? manufacturerHex;

      if (device.manufacturerData.isNotEmpty && device.manufacturerData.length >= 2) {
        final bytes = device.manufacturerData;
        final byteData = ByteData.sublistView(bytes);
        manufacturerId = byteData.getUint16(0, Endian.little); // first 2 bytes
        manufacturerHex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase();
      }

      final shouldAdd = showAll || BleDeviceFilterUtils.isLikelyPhoneOrWatch(name, manufacturerId);

      if (shouldAdd) {
        foundDevices[id] = BleDeviceEntity(
          id: device.id,
          name: name,
          rssi: device.rssi,
          manufacturerId: manufacturerId,
          manufacturerHex: manufacturerHex,
        );

        final sorted = foundDevices.values.toList()
          ..sort((a, b) => b.rssi.compareTo(a.rssi)); // strongest first

        yield sorted;
      }
    }
  }

  @override
  Stream<ConnectionStateUpdate> connect(String deviceId) {
    logger.d("TFDB: BleDeviceDataSource: connect: deviceId=[$deviceId]");

    return _ble.connectToDevice(id: deviceId);
  }
}
