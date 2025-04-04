import 'package:test_flutter_dummy_mvvm_clean_bloc/data/remote/my_string_remote_data_source.dart';

import '../local/my_string_hive_data_source.dart';
import '../local/my_string_local_data_source.dart';
import '../local/my_string_shared_prefs_data_source.dart';
import '../remote/my_string_dio_data_source.dart';
import '../remote/my_string_http_data_source.dart';
import '../remote/my_string_simulator_data_source.dart';

// Code for manual dependency injection is included here.
//
// For more complex apps, consider using a framework such as provider, riverpod.

// =============================================================================
// Local Store

enum LocalStore { sharedPrefs, hive }

MyStringLocalDataSource createLocalDataSource(LocalStore storeType) {
  switch (storeType) {
    case LocalStore.sharedPrefs:
      return MyStringSharedPrefsDataSource();
    case LocalStore.hive:
      return MyStringHiveDataSource();
  }
}

// =============================================================================
// Remote Server

enum RemoteServer { simulator, dio, http }

MyStringRemoteDataSource createRemoteDataSource(RemoteServer serverType) {
  switch (serverType) {
    case RemoteServer.simulator:
      return MyStringSimulatorDataSource();
    case RemoteServer.dio:
      return MyStringDioDataSource();
    case RemoteServer.http:
      return MyStringHttpDataSource();
  }
}

// =============================================================================
// TODO: Change these values when choosing different solution providers.
//
// Furthermore, these choices can be stored somewhere else, such as in an
// external configuration file.

final storeTypeSelected = LocalStore.hive;
final serverTypeSelected = RemoteServer.simulator;
