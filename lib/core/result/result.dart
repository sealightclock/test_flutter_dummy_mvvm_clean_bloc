/// A simple sealed class to represent either Success or Failure outcomes.
///
/// This pattern avoids using exceptions and makes error handling more declarative.
///
/// `Result<T>` is a generic type that represents the outcome of an operation:
/// - If successful, it holds a `Success<T>`
/// - If failed, it holds a `Failure<T>`
sealed class Result<T> {
  const Result();

  /// Transforms the data in [Success] using the provided [transform] function.
  ///
  /// If this is a [Success<T>], it applies [transform] to the data and returns a new [Success<R>].
  /// If this is a [Failure<T>], it returns the same failure, retyped as [Failure<R>].
  ///
  /// This allows you to map between different layers (e.g., Domain → UI).
  Result<R> map<R>(R Function(T) transform) {
    if (this is Success<T>) {
      final data = (this as Success<T>).data;
      return Success<R>(transform(data));
    } else if (this is Failure<T>) {
      final message = (this as Failure<T>).message;
      return Failure<R>(message);
    }

    // This should never be reached unless new subtypes are added without updating this method.
    throw StateError('Unknown Result subtype: $this');
  }
}

/// Success result carrying a value of type [T].
final class Success<T> extends Result<T> {
  final T data;

  /// Use "const" to allow compile-time constant success objects when possible.
  const Success(this.data);
}

/// Failure result carrying an error message.
///
/// The generic [T] is kept for compatibility with [Result<T>] but unused here.
final class Failure<T> extends Result<T> {
  final String message;

  /// Use "const" for consistency and immutability.
  const Failure(this.message);
}
