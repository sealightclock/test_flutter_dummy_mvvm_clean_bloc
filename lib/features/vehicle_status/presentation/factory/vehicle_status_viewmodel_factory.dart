import '../../data/datasource/platform/vehicle_status_data_source.dart';
import '../../data/repository/vehicle_status_repository.dart';
import '../../domain/usecase/check_and_request_location_permission_use_case.dart';
import '../../domain/usecase/get_vehicle_status_use_case.dart';
import '../viewmodel/vehicle_status_viewmodel.dart';

/// Factory class to create [VehicleStatusViewModel] with all required dependencies.
///
/// This separates the construction logic from the ViewModel,
/// aligning with Clean Architecture and allowing easy testing and replacement.
class VehicleStatusViewModelFactory {
  static VehicleStatusViewModel create() {
    // Step 1: Create the lowest-level data source (e.g., API or simulator)
    final dataSource = VehicleStatusDataSource();

    // Step 2: Create repository that uses the data source
    final repository = VehicleStatusRepository(dataSource: dataSource);

    // Step 3: Create use cases that use the repository
    final getVehicleStatusUseCase = GetVehicleStatusUseCase(repository: repository);
    final checkAndRequestLocationPermissionUseCase = CheckAndRequestLocationPermissionUseCase(repository: repository);


    // Step 4: Inject the use cases into the ViewModel
    return VehicleStatusViewModel(
      getVehicleStatusUseCase: getVehicleStatusUseCase,
      checkAndRequestLocationPermissionUseCase: checkAndRequestLocationPermissionUseCase,
    );
  }
}

