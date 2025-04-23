sealed class BleEvent {}

class StartScanEvent extends BleEvent {}

class DeviceSelectedEvent extends BleEvent {
  final String deviceId;
  DeviceSelectedEvent(this.deviceId);
}

class DisconnectFromDeviceEvent extends BleEvent {} // NEW

/// Internal only
class ConnectedInternally extends BleEvent {
  final String deviceId;
  ConnectedInternally(this.deviceId);
}
