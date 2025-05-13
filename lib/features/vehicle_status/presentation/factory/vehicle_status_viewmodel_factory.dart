import '../../../../app/core/permission/permission_manager.dart';
import '../../data/datasource/platform/vehicle_status_data_source.dart';
import '../../data/repository/vehicle_status_repository.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';
import '../viewmodel/vehicle_status_viewmodel.dart';

/// Factory for creating VehicleStatusViewModel with required dependencies.
///
/// This approach allows better testability and separation of wiring code.
class VehicleStatusViewModelFactory {
  static VehicleStatusViewModel create() {
    // Step 1: Create the lowest-level data source (e.g., API or simulator)
    final dataSource = VehicleStatusDataSource();

    // Step 2: Create repository that uses the data source
    final repository = VehicleStatusRepository(dataSource: dataSource);

    // Step 3: Create use cases that use the repository, and other dependencies
    final getVehicleStatusUseCase = GetVehicleStatusUseCase(repository: repository);
    final permissionManager = PermissionManager();

    // Step 4: Inject the use cases and other dependencies into the ViewModel
    return VehicleStatusViewModel(
      getVehicleStatusUseCase: getVehicleStatusUseCase,
      permissionManager: permissionManager,
    );
  }
}

