import 'package:test_flutter_dummy_mvvm_clean_bloc/data/remote/my_string_remote_data_source.dart';

import '../local/my_string_hive_data_source.dart';
import '../local/my_string_local_data_source.dart';
import '../local/my_string_shared_prefs_data_source.dart';
import '../remote/my_string_dio_data_source.dart';
import '../remote/my_string_http_data_source.dart';
import '../remote/my_string_simulator_data_source.dart';

// ===================================================================================
// Manual Dependency Injection
//
// This file controls which Local and Remote Data Source will be used in the app.
//
// For simple apps, manual DI is easy and fast.
// For larger apps, consider using a library like Provider, Riverpod, or GetIt.
// ===================================================================================

// -------------------------------------------------------------------------------
// Step 1: Define Enums for Local Store and Remote Server Options
// -------------------------------------------------------------------------------

/// Enum to select which Local Store to use
enum LocalStore { sharedPrefs, hive }

/// Enum to select which Remote Server to use
enum RemoteServer { simulator, dio, http }

// -------------------------------------------------------------------------------
// Step 2: Create Functions to Build Data Sources
// -------------------------------------------------------------------------------

/// Factory function to create a Local Data Source based on selected type
MyStringLocalDataSource createLocalDataSource(LocalStore storeType) {
  switch (storeType) {
    case LocalStore.sharedPrefs:
      return MyStringSharedPrefsDataSource();
    case LocalStore.hive:
      return MyStringHiveDataSource();
  }
  // Validation fallback: should never reach here
  throw ArgumentError('Unsupported LocalStore type: $storeType');
}

/// Factory function to create a Remote Data Source based on selected type
MyStringRemoteDataSource createRemoteDataSource(RemoteServer serverType) {
  switch (serverType) {
    case RemoteServer.simulator:
      return MyStringSimulatorDataSource();
    case RemoteServer.dio:
      return MyStringDioDataSource();
    case RemoteServer.http:
      return MyStringHttpDataSource();
  }
  // Validation fallback: should never reach here
  throw ArgumentError('Unsupported RemoteServer type: $serverType');
}

// -------------------------------------------------------------------------------
// Step 3: Choose which Local Store and Remote Server to use
// -------------------------------------------------------------------------------

// TIP: You can quickly switch these values during development/testing
//
// Later, you can load these settings from a config file or API response,
// making the app fully dynamic without code changes.

/// The currently selected Local Store for the app
final LocalStore storeTypeSelected = LocalStore.hive;

/// The currently selected Remote Server for the app
final RemoteServer serverTypeSelected = RemoteServer.simulator;

// -------------------------------------------------------------------------------
// End of Manual Dependency Injection setup
// -------------------------------------------------------------------------------
