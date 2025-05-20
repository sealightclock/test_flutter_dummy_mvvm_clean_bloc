sealed class BleEvent {}

class BleStartScanEvent extends BleEvent {
  final bool showAll;

  BleStartScanEvent({required this.showAll});
}

class BleStopScanEvent extends BleEvent {}

class BleSelectDeviceEvent extends BleEvent {
  final String deviceId;

  BleSelectDeviceEvent(this.deviceId);
}

class BleDisconnectDeviceEvent extends BleEvent {
  final String deviceId;

  BleDisconnectDeviceEvent(this.deviceId);
}

class BleShowReconnectingDeviceEvent extends BleEvent {
  final String deviceId;

  BleShowReconnectingDeviceEvent(this.deviceId);
}
