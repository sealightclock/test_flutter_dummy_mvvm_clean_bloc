import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../../domain/entity/ble_device_entity.dart';

class BleViewModel {
  final ScanBleDevicesUseCase scanUseCase;
  final ConnectToBleDeviceUseCase connectUseCase;

  BleViewModel(this.scanUseCase, this.connectUseCase);

  Stream<List<BleDeviceEntity>> scanBleDevices({required bool showAll}) {
    return scanUseCase.execute(showAll: showAll);
  }

  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return connectUseCase.connect(deviceId);
  }

  Future<bool> requestPermissions() async {
    final permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ];
    final results = await permissions.request();
    return results.values.every((status) => status.isGranted);
  }
}
