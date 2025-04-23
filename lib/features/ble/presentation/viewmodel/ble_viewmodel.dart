
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../domain/entity/ble_device_entity.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';

class BleViewModel {
  final ScanBleDevicesUseCase scanUseCase;
  final ConnectToBleDeviceUseCase connectUseCase;

  BleViewModel(this.scanUseCase, this.connectUseCase);

  Stream<List<BleDeviceEntity>> scanBleDevices() {
    return scanUseCase.execute();
  }

  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return connectUseCase.connect(deviceId);
  }
}
