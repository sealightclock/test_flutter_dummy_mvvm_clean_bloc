sealed class BleEvent {}

class StartScanEvent extends BleEvent {
  final bool showAll;
  StartScanEvent({this.showAll = false});
}

class DeviceSelectedEvent extends BleEvent {
  final String deviceId;
  DeviceSelectedEvent(this.deviceId);
}

class DisconnectFromDeviceEvent extends BleEvent {}

class ShowReconnectingEvent extends BleEvent {
  final String deviceId;
  ShowReconnectingEvent(this.deviceId);
}
