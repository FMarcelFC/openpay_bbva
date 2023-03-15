import '../models/openpay_error.dart';

export '../models/openpay_error.dart';

///Openpay returns JSON objects in service responses, even in case of errors so when there is an error.
class OpenpayExceptionError implements Exception {
  /// The [error] is the [OpenpayError] object that contains the error information.
  final OpenpayError? error;

  /// The [message] is the message that will be shown when the error is thrown.
  final String message;

  OpenpayExceptionError({
    this.message = "Openpay Exception",
    this.error,
  });

  @override
  String toString() {
    return error != null
        ? 'Exception: Http: ${error!.httpCode}'
            ' - Openpay Error: ${error!.errorCode}'
            ' - Desciption: ${error!.description}'
        : message;
  }
}
