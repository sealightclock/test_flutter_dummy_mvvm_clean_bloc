/// Immutable model class representing a string value.
///
/// This "Model" class is primarily used in the Presentation layer.
///
/// However, it may needs to be converted to the Domain layer.
class MyStringModel {
  final String value;

  // Use "required" for clarity.
  const MyStringModel({required this.value});
}
