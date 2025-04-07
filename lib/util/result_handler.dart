import 'result.dart'; // Import your Result class (Success, Failure)

/// Handles a Future<Result<T>> cleanly without repeating switch-cases.
///
/// This helper calls [onSuccess] if Result is Success,
/// and calls [onFailure] if Result is Failure.
///
/// Useful for making ViewModels, UI, and Tests much cleaner.
///
/// Example usage:
/// ```dart
/// await handleResult(
///   await useCase.execute(),
///   onSuccess: (data) { ... },
///   onFailure: (message) { ... },
/// );
/// ```
Future<void> handleResult<T>(
    Future<Result<T>> futureResult, {
      required void Function(T data) onSuccess,
      required void Function(String message) onFailure,
    }) async {
  await _internalHandleResult<T, void>(
    futureResult,
    onSuccess: (data) {
      onSuccess(data);
      return null; // We don't care about returning anything for void version
    },
    onFailure: (message) {
      onFailure(message);
      return null;
    },
  );
}

/// Handles a Future<Result<T>> and RETURNS a value.
///
/// This version is used when you want to return something from Success or Failure,
/// for example inside a function like Future<String> fetchAndStore().
///
/// Example usage:
/// ```dart
/// final resultString = await handleResultReturning(
///   await useCase.execute(),
///   onSuccess: (data) => data.value,
///   onFailure: (message) => 'Error: $message',
/// );
/// ```
Future<R> handleResultReturning<T, R>(
    Future<Result<T>> futureResult, {
      required R Function(T data) onSuccess,
      required R Function(String message) onFailure,
    }) async {
  return await _internalHandleResult(futureResult, onSuccess: onSuccess, onFailure: onFailure);
}

/// Internal helper that both [handleResult] and [handleResultReturning] use.
///
/// [T] = type inside Result (e.g., MyStringEntity)
/// [R] = return type (void for handleResult, or String/etc. for handleResultReturning)
Future<R> _internalHandleResult<T, R>(
    Future<Result<T>> futureResult, {
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
