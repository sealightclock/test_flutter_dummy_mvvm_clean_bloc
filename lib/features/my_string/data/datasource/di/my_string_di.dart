// ===================================================================================
// Manual Dependency Injection
//
// This file controls which Local and Remote Data Source will be used in the core.
//
// For simple apps, manual DI is easy and fast.
// For larger apps, consider using a library like Provider, Riverpod, or GetIt.
// ===================================================================================

import '../../../../../shared/enums/local_store_enum.dart';
import '../../../../../shared/enums/remote_server_enum.dart';
import '../local/my_string_hive_data_source.dart';
import '../local/my_string_local_data_source.dart';
import '../local/my_string_shared_prefs_data_source.dart';
import '../remote/my_string_dio_data_source.dart';
import '../remote/my_string_http_data_source.dart';
import '../remote/my_string_remote_data_source.dart';
import '../remote/my_string_simulator_data_source.dart';

// -------------------------------------------------------------------------------
// Factory Methods to Create Data Sources Based on Config
// -------------------------------------------------------------------------------

/// Factory function to create a Local Data Source based on DI config
MyStringLocalDataSource createLocalDataSource(LocalStore storeType) {
  switch (storeType) {
    case LocalStore.sharedPrefs:
      return MyStringSharedPrefsDataSource();
    case LocalStore.hive:
      return MyStringHiveDataSource();
  }
  // Fallback — should never occur
  // ignore: dead_code
  throw ArgumentError('Unsupported LocalStore type: $storeType');
}

/// Factory function to create a Remote Data Source based on DI config
MyStringRemoteDataSource createRemoteDataSource(RemoteServer serverType) {
  switch (serverType) {
    case RemoteServer.simulator:
      return MyStringSimulatorDataSource();
    case RemoteServer.dio:
      return MyStringDioDataSource();
    case RemoteServer.http:
      return MyStringHttpDataSource();
  }
  // Fallback — should never occur
  // ignore: dead_code
  throw ArgumentError('Unsupported RemoteServer type: $serverType');
}
