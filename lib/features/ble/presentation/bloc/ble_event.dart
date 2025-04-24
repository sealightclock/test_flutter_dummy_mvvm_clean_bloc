sealed class BleEvent {}

class StartScanEvent extends BleEvent {
  final bool showAll;
  StartScanEvent({required this.showAll});
}

class StopScanEvent extends BleEvent {}

class DeviceSelectedEvent extends BleEvent {
  final String deviceId;
  DeviceSelectedEvent(this.deviceId);
}

class DisconnectFromDeviceEvent extends BleEvent {}

class ShowReconnectingEvent extends BleEvent {
  final String deviceId;
  ShowReconnectingEvent(this.deviceId);
}
