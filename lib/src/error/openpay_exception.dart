import '../models/openpay_error.dart';

export '../models/openpay_error.dart';

/// Exception thrown when an Openpay API request fails.
///
/// Openpay always returns structured JSON error objects in its error responses.
/// This exception wraps an [OpenpayError] (when available) so callers can
/// inspect the HTTP status code, Openpay error code, and human-readable
/// description.
///
/// ## Example
///
/// ```dart
/// try {
///   final token = await openpay.getCardToken(card);
/// } on OpenpayExceptionError catch (e) {
///   print(e.error?.errorCode);   // e.g. 3001 (card declined)
///   print(e.error?.description); // "The card was declined."
///   print(e);                    // formatted string representation
/// }
/// ```
///
/// See [OpenpayError] for the full list of error codes and their meanings.
class OpenpayExceptionError implements Exception {
  /// Creates an [OpenpayExceptionError].
  ///
  /// - [error]: The structured [OpenpayError] returned by the API. May be
  ///   `null` for non-API errors (e.g., network issues).
  /// - [message]: A fallback message shown when [error] is `null`.
  OpenpayExceptionError({
    this.message = 'Openpay Exception',
    this.error,
  });

  /// The structured error object returned by Openpay, if available.
  ///
  /// Contains the HTTP status code, Openpay error code, category, and
  /// human-readable description. See [OpenpayError] for details.
  final OpenpayError? error;

  /// Fallback message used when no [OpenpayError] is available.
  final String message;

  @override
  String toString() {
    return error != null
        ? 'OpenpayException — HTTP ${error!.httpCode}'
            ' | Openpay error ${error!.errorCode}'
            ' | ${error!.description}'
        : 'OpenpayException: $message';
  }
}
