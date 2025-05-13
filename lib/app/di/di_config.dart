import '../util/enums/local_store_enum.dart';
import '../util/enums/remote_server_enum.dart';

/// Singleton-style config class for managing DI choices in the app.
class DiConfig {
  static LocalStore localStore = LocalStore.hive;
  static RemoteServer remoteServer = RemoteServer.simulator;

  static void useHiveAndSimulator() {
    localStore = LocalStore.hive;
    remoteServer = RemoteServer.simulator;
  }

  static void usePrefsAndHttp() {
    localStore = LocalStore.sharedPrefs;
    remoteServer = RemoteServer.http;
  }

  static void resetToDefaults() {
    localStore = LocalStore.hive;
    remoteServer = RemoteServer.simulator;
  }
}
