import '../../domain/entity/my_string_entity.dart';

import 'my_string_remote_data_source.dart';

/// Data Source handler for fetching data from a simulator.
class MyStringSimulatorDataSource implements MyStringRemoteDataSource {
  static const int _delaySeconds = 10; // Simulate network delay.

  /// Fetches data from the simulator.
  @override
  Future<MyStringEntity> getMyString() async {
      await Future.delayed(Duration(seconds: _delaySeconds)); // Simulate network delay.
      return MyStringEntity(value: 'MyStringSimulatorDataSource: Mocked Server '
          'String: ${DateTime.now()}');
  }

  @override
  Future<void> storeMyString(MyStringEntity value) {
    // TODO: Implement storeMyString
    throw UnimplementedError();
  }
}
