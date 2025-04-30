import '../../domain/entity/vehicle_status_entity.dart';

/// Sealed class for Bloc Events.
sealed class VehicleStatusEvent {
  const VehicleStatusEvent();
}

class VehicleStatusStartedEvent extends VehicleStatusEvent {}

class VehicleStatusPermissionCheckedEvent extends VehicleStatusEvent {
  final bool permissionGranted;
  const VehicleStatusPermissionCheckedEvent(this.permissionGranted);
}

class VehicleStatusUpdatedEvent extends VehicleStatusEvent {
  final VehicleStatusEntity status;
  const VehicleStatusUpdatedEvent(this.status);
}
