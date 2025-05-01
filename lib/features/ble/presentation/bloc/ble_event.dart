sealed class BleEvent {}

class BleStartScanEvent extends BleEvent {
  final bool showAll;
  BleStartScanEvent({required this.showAll});
}

class BleStopScanEvent extends BleEvent {}

class BleDeviceSelectedEvent extends BleEvent {
  final String deviceId;
  BleDeviceSelectedEvent(this.deviceId);
}

class BleDisconnectFromDeviceEvent extends BleEvent {
  final String deviceId;
  BleDisconnectFromDeviceEvent(this.deviceId);
}

class BleShowReconnectingEvent extends BleEvent {
  final String deviceId;
  BleShowReconnectingEvent(this.deviceId);
}
