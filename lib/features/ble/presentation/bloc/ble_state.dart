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

class BleConnectedState extends BleState {
  final String deviceId;
  final ConnectionStateUpdate? update;

  const BleConnectedState(this.deviceId, {this.update});

  @override
  List<Object?> get props => [deviceId, update];
}

class BleDisconnectedState extends BleState {
  final String deviceId;
  @override
  final List<BleDeviceEntity> devices;
  const BleDisconnectedState(this.deviceId, this.devices);

  @override
  List<Object?> get props => [devices];
}

class BleReconnectingState extends BleState {
  final String deviceId;
  const BleReconnectingState(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class BleErrorState extends BleState {
  final String message;
  const BleErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
