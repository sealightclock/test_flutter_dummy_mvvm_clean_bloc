import '../../domain/entity/vehicle_status_entity.dart';

/// Sealed class for Bloc Events.
sealed class VehicleStatusEvent {
  const VehicleStatusEvent();
}

class VehicleStatusStartEvent extends VehicleStatusEvent {}

class VehicleStatusHandlePermissionEvent extends VehicleStatusEvent {
  final bool permissionGranted;
  const VehicleStatusHandlePermissionEvent(this.permissionGranted);
}

class VehicleStatusLoadEvent extends VehicleStatusEvent {
  final VehicleStatusEntity vehicleStatus;
  const VehicleStatusLoadEvent(this.vehicleStatus);
}
