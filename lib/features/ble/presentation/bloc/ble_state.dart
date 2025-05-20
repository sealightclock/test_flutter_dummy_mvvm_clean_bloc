import 'package:equatable/equatable.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../domain/entity/ble_device_entity.dart';

abstract class BleState extends Equatable {
  const BleState();

  @override
  List<Object?> get props => [];

  get devices => null;
}

class BleInitialState extends BleState {}

class BleScanningState extends BleState {}

class BleDevicesFoundState extends BleState {
  @override
  final List<BleDeviceEntity> devices;

  const BleDevicesFoundState(this.devices);

  @override
  List<Object?> get props => [devices];
}

class BleDeviceConnectedState extends BleState {
  final String deviceId;
  final ConnectionStateUpdate? connectionStatusUpdate;

  const BleDeviceConnectedState(this.deviceId, {this.connectionStatusUpdate});

  @override
  List<Object?> get props => [deviceId, connectionStatusUpdate];
}

class BleDeviceDisconnectedState extends BleState {
  final String deviceId;
  @override
  final List<BleDeviceEntity> devices;

  const BleDeviceDisconnectedState(this.deviceId, this.devices);

  @override
  List<Object?> get props => [deviceId, devices];
}

class BleDeviceReconnectingState extends BleState {
  final String deviceId;

  const BleDeviceReconnectingState(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class BleErrorState extends BleState {
  final String message;

  const BleErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
