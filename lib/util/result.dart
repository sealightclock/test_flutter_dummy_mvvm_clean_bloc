/// A simple sealed class to represent either Success or Failure outcomes.
///
/// This pattern avoids using exceptions and makes error handling more declarative.
sealed class Result<T> {
  const Result();
}

/// Success result carrying a value.
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

/// Failure result carrying an error message.
final class Failure<T> extends Result<T> {
  final String message;

  const Failure(this.message);
}
