import '../../domain/entity/vehicle_status_entity.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';

/// ViewModel responsible for interacting with the UseCase and exposing data to the Bloc.
class VehicleStatusViewModel {
  final GetVehicleStatusUseCase _useCase;

  VehicleStatusViewModel() : _useCase = GetVehicleStatusUseCase();

  Stream<VehicleStatusEntity> get vehicleStatusStream => _useCase();
}
