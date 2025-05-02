import '../../data/repository/vehicle_status_repository.dart';
import '../entity/vehicle_status_entity.dart';

/// UseCase class to provide a clean entry point to get the vehicle status stream.
class GetVehicleStatusUseCase {
  late final VehicleStatusRepository repository;

  GetVehicleStatusUseCase({required this.repository});

  Stream<VehicleStatusEntity> call() {
    return repository.getVehicleStatusStream();
  }
}
