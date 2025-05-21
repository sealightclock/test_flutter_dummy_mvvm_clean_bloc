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
/// However, it may need to be converted to the Presentation and Domain layers.
class MyStringEntity {
  final String value;

  // Use "required" for clarity.
  const MyStringEntity({required this.value});
}
