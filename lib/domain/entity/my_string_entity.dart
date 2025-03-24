/// As there is no Kotlin-like "data class" in Dart, this is the simplest
/// class that contains a single primitive data of type string.
/// "final" to make it immutable.
/// "const" to make it compile-time constant.
///
/// Immutable entity class representing a string value.
/// "Entity" is alternatively known as "Model" or "DataModel".
class MyStringEntity {
  final String value;

  const MyStringEntity(this.value);
}
