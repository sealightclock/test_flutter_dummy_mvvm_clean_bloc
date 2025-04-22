import 'result.dart'; // Import your Result class (Success, Failure)

/// Handles a `Future<Result<T>>` cleanly without repeating switch-cases.
///
/// This helper calls [onSuccess] if Result is Success,
/// and calls [onFailure] if Result is Failure.
///
/// Useful for making ViewModels, UI, and Tests much cleaner.
///
/// Example usage:
/// ```dart
/// await handleResult(
///   futureResult: await useCase.call(),
///   onSuccess: (data) { ... },
///   onFailure: (message) { ... },
/// );
/// ```
Future<void> handleResult<T>({
  required Future<Result<T>> futureResult,
  required void Function(T data) onSuccess,
  required void Function(String message) onFailure,
}) async {
  final result = await futureResult;
  switch (result) {
    case Success(:final data):
      onSuccess(data);
      break;
    case Failure(:final message):
      onFailure(message);
      break;
  }
}

/// Handles a `Future<Result<T>>` and RETURNS a value.
///
/// This version is used when you want to return something from Success or Failure.
///
/// Example usage:
/// ```dart
/// final resultString = await handleResultReturning(
///   futureResult: await useCase.call(),
///   onSuccess: (data) => data.value,
///   onFailure: (message) => 'Error: $message',
/// );
/// ```
Future<R> handleResultReturning<T, R>({
  required Future<Result<T>> futureResult,
  required R Function(T data) onSuccess,
  required R Function(String message) onFailure,
}) async {
  final result = await futureResult;
  switch (result) {
    case Success(:final data):
      return onSuccess(data);
    case Failure(:final message):
      return onFailure(message);
  }
}
