import '../../data/repository/vehicle_status_repository.dart';
import '../entity/vehicle_status_entity.dart';

/// UseCase class to provide a clean entry point to get the vehicle status stream.
class GetVehicleStatusUseCase {
  final VehicleStatusRepository _repository;

  GetVehicleStatusUseCase() : _repository = VehicleStatusRepository();

  Stream<VehicleStatusEntity> call() {
    return _repository.getVehicleStatusStream();
  }
}
