import 'app_constants.dart';

/// Enum to select which Remote Server to use
enum RemoteServer {
  simulator,
  dio,
  http;

  /// Returns label for display/debug
  String get label {
    switch (this) {
      case RemoteServer.simulator:
        return AppConstants.remoteServerLabelSimulator;
      case RemoteServer.dio:
        return AppConstants.remoteServerLabelDio;
      case RemoteServer.http:
        return AppConstants.remoteServerLabelHttp;
    }
  }
}
