import 'package:equatable/equatable.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../domain/entity/ble_device_entity.dart';

abstract class BleState extends Equatable {
  const BleState();
  @override
  List<Object?> get props => [];

  get devices => null;
}

class BleInitial extends BleState {}

class BleScanning extends BleState {}

class BleDevicesFound extends BleState {
  @override
  final List<BleDeviceEntity> devices;
  const BleDevicesFound(this.devices);

  @override
  List<Object?> get props => [devices];
}

class BleConnected extends BleState {
  final String deviceId;
  final ConnectionStateUpdate? update;

  const BleConnected(this.deviceId, {this.update});

  @override
  List<Object?> get props => [deviceId, update];
}

class BleDisconnected extends BleState {
  final String deviceId;
  @override
  final List<BleDeviceEntity> devices;
  const BleDisconnected(this.deviceId, this.devices);

  @override
  List<Object?> get props => [devices];
}

class BleReconnecting extends BleState {
  final String deviceId;
  const BleReconnecting(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class BleError extends BleState {
  final String message;
  const BleError(this.message);

  @override
  List<Object?> get props => [message];
}
