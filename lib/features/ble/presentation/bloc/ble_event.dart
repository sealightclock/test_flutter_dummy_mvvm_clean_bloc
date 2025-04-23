sealed class BleEvent {}

class StartScanEvent extends BleEvent {}

class DeviceSelectedEvent extends BleEvent {
  final String deviceId;
  DeviceSelectedEvent(this.deviceId);
}
