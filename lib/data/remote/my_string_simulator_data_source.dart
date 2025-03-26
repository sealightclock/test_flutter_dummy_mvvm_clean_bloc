import '../../domain/entity/my_string_entity.dart';
import 'my_string_remote_data_source.dart';

/// Data Source handler for fetching data from a simulator.
class MyStringSimulatorDataSource implements MyStringRemoteDataSource {
  /// Fetches data from the simulator.
  @override
  Future<MyStringEntity> getMyString() async {
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay.
      return MyStringEntity(value: 'MyStringSimulatorDataSource: Mocked Server '
          'String: ${DateTime.now()}');
  }

  @override
  Future<void> storeMyString(MyStringEntity value) {
    // TODO: Implement storeMyString
    throw UnimplementedError();
  }
}
