import '../../domain/entity/my_string_entity.dart';
import 'my_string_model.dart';

/// A utility class to convert between Domain Entity and Presentation Model.
///
/// This allows ViewModel logic to stay clean and focused,
/// while keeping conversion logic reusable and testable.
class MyStringUiMapper {
  /// Domain Entity → Presentation Model
  static MyStringModel toModel(MyStringEntity entity) {
    return MyStringModel(value: entity.value);
  }

  /// Presentation Model → Domain Entity
  static MyStringEntity toEntity(MyStringModel model) {
    return MyStringEntity(value: model.value);
  }
}
