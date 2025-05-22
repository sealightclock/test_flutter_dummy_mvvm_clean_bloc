import '../../../../shared/constants/app_constants.dart';
import '../../domain/entity/my_string_entity.dart';
import '../datasource/local/hive/my_string_hive_data_mapper.dart';
import '../datasource/local/hive/my_string_hive_data_source.dart';
import '../datasource/local/my_string_local_data_source.dart';
import '../datasource/remote/my_string_remote_data_source.dart';
import 'my_string_repository.dart';

/// This 2nd-level repository implementation is responsible for talking to
/// different data sources and converting between DTOs and domain entities.
///
/// 🔁 Some local sources (e.g. Hive) use a custom DTO format.
/// ✅ All conversions are done here to keep DataSources decoupled.
class MyStringRepositoryImpl implements MyStringRepository {
  final MyStringLocalDataSource? localDataSource; // e.g. SharedPrefs
  final MyStringRemoteDataSource remoteDataSource;
  final MyStringHiveDataSource? hiveDataSource;

  MyStringRepositoryImpl({
    this.localDataSource,
    required this.remoteDataSource,
    this.hiveDataSource,
  });

  @override
  Future<MyStringEntity> getMyStringFromLocal() async {
    if (localDataSource != null) {
      // Case 1: SharedPrefs or other entity-based source
      return await localDataSource!.getMyString();
    } else if (hiveDataSource != null) {
      // Case 2: Hive source uses DTOs, so convert here
      final dto = await hiveDataSource!.getMyStringDto();
      if (dto == null) {
        // If no value stored, return a default
        return const MyStringEntity(value: AppConstants.defaultValueHive);
      } else {
        return MyStringHiveDataMapper.toEntity(dto);
      }
    } else {
      throw Exception('No local data source provided.');
    }
  }

  @override
  Future<void> storeMyStringToLocal(MyStringEntity value) async {
    if (localDataSource != null) {
      await localDataSource!.storeMyString(value);
    } else if (hiveDataSource != null) {
      final dto = MyStringHiveDataMapper.toDto(value);
      await hiveDataSource!.storeMyStringDto(dto);
    } else {
      throw Exception('No local data source provided.');
    }
  }

  @override
  Future<MyStringEntity> getMyStringFromRemote() {
    return remoteDataSource.getMyString();
  }
}
