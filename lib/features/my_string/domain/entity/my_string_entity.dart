import 'package:hive/hive.dart';

part 'my_string_entity.g.dart';

/// Immutable entity class representing a string value.
///
/// "Entity" is alternatively known as "Model" or "DataModel" or "Entry".
///
/// As there is no Kotlin-like "data class" in Dart, this is the simplest
/// class that contains a single primitive data of type string.
/// "final" to make it immutable.
/// "const" to make it compile-time constant.
///
/// This "Entity" class is primarily used in the Domain layer.
///
/// Make this class Hive-compatible by adding the @HiveType annotation.
/// This should work for both Hive and SharedPreferences on the Data layer.
/// However, it may need to adapt to the Presentation layer.
@HiveType(typeId: 0)
class MyStringEntity {
  @HiveField(0)
  final String value;

  // Use "required" for clarity.
  const MyStringEntity({required this.value});
}
