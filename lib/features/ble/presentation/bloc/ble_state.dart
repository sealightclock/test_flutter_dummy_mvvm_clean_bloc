import '../../domain/entity/ble_device_entity.dart';

sealed class BleState {}

class BleInitial extends BleState {}

class BleScanning extends BleState {}

class BleDevicesFound extends BleState {
  final List<BleDeviceEntity> devices;
  BleDevicesFound(this.devices);
}

class BleConnected extends BleState {
  final String deviceId;
  BleConnected(this.deviceId);
}

class BleDisconnected extends BleState {}

class BleError extends BleState {
  final String message;
  BleError(this.message);
}
