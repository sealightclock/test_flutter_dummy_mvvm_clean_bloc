import 'package:hive/hive.dart';

import '../../../../domain/entity/my_string_entity.dart';

part 'my_string_hive_dto.g.dart';

/// Immutable Data Transfer Object (DTO) class representing a string value.
///
/// This DTO class is primarily used in the Data layer, especially for Hive.
///
/// Make this class Hive-compatible by adding the @HiveType annotation.
///
/// It may need to be converted to the Domain layer.
@HiveType(typeId: 0)
class MyStringHiveDto {
  @HiveField(0)
  final String value;

  // Use "required" for clarity.
  const MyStringHiveDto({required this.value});

  MyStringEntity toEntity() => MyStringEntity(value: value);
}
