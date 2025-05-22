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
import '../local/hive/my_string_hive_data_source.dart'; // ✅ NEW DTO-based Hive data source
import '../local/my_string_local_data_source.dart';
import '../local/shared_prefs/my_string_shared_prefs_data_source.dart';
import '../remote/dio/my_string_dio_data_source.dart';
import '../remote/http/my_string_http_data_source.dart';
import '../remote/my_string_remote_data_source.dart';
import '../remote/simulator/my_string_simulator_data_source.dart';

/// Factory function to create a Local Entity-based Data Source
///
/// This returns a [MyStringLocalDataSource], which is used when the local
/// implementation works directly with [MyStringEntity] (e.g., SharedPrefs).
MyStringLocalDataSource? createLocalDataSource(LocalStore storeType) {
  switch (storeType) {
    case LocalStore.sharedPrefs:
      return MyStringSharedPrefsDataSource();
    case LocalStore.hive:
      return null; // ❌ Hive does not return a MyStringEntity-based data source
  }

  // Fallback — should never occur
  // ignore: dead_code
  throw ArgumentError('Unsupported LocalStore type: $storeType');
}

/// Factory function to create a Local Hive DTO-based Data Source
///
/// This returns a [MyStringHiveLocalDataSource] if Hive is selected.
/// Other sources will return null.
MyStringHiveDataSource? createHiveDtoDataSource(LocalStore storeType) {
  switch (storeType) {
    case LocalStore.hive:
      return MyStringHiveDataSource();
    case LocalStore.sharedPrefs:
      return null; // ❌ Not applicable
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
