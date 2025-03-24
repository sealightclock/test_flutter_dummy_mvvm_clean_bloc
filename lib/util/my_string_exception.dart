/// Exception class for handling predictable errors.
class MyStringException implements Exception {
  final String message;

  MyStringException(this.message);

  @override
  String toString() => message;
}
