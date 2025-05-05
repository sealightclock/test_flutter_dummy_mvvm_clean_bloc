import '../../data/repository/vehicle_status_repository.dart';
import '../entity/vehicle_status_entity.dart';

/// UseCase class to provide a clean entry point to get the vehicle status stream.
class GetVehicleStatusUseCase {
  late final VehicleStatusRepository repository;

  GetVehicleStatusUseCase({required this.repository});

  // Do not wrap Stream into Result<T>, as it has its own error handling mechanism.
  Stream<VehicleStatusEntity> call() {
    return repository.getVehicleStatusStream();
  }
}
