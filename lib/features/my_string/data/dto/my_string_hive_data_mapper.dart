import '../../domain/entity/my_string_entity.dart';
import 'my_string_hive_dto.dart';

/// A utility class to convert between Domain Entity and Presentation Model.
///
/// This allows Data processing logic to stay clean and focused,
/// while keeping conversion logic reusable and testable.
class MyStringHiveDataMapper {
  /// Domain Entity → Data Transfer Object
  static MyStringHiveDto toDto(MyStringEntity entity) {
    return MyStringHiveDto(value: entity.value);
  }

  /// Data Transfer Object → Domain Entity
  static MyStringEntity toEntity(MyStringHiveDto dto) {
    return MyStringEntity(value: dto.value);
  }
}
