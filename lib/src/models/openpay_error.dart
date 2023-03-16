// To parse this JSON data, do
//
//     final openpayError = openpayErrorFromJson(jsonString);
import 'dart:convert';

OpenpayError openpayErrorFromJson(String str) =>
    OpenpayError.fromJson(json.decode(str));

String openpayErrorToJson(OpenpayError data) => json.encode(data.toJson);

/// OpenpayError is a class that contains the error information.
///
/// ## Tables of Error Codes
///
/// ### General Error Codes
///
/// | Openpay Code | HTTP Code|        Error HTTP            |                                                        Cause                                                               |
/// |-------------:|---------:|:----------------------------:|----------------------------------------------------------------------------------------------------------------------------|
/// |     1000     |    500   |    Internal Server Error     |   An internal error occurred in the Openpay server.                                                                        |
/// |     1001     |    400   |    Bad Request               |   The request format is not JSON, the fields are not in the correct format, or the request is missing required fields.     |
/// |     1002     |    401   |    Unauthorized              |   The call is not authenticated or the authentication is incorrect.                                                        |
/// |     1003     |    422   |    Unprocessable Entity      |   The operation could not be completed because the value of one or more parameters is incorrect.                           |
/// |     1004     |    503   |    Service Unavailable       |   A service required for transaction processing is not available.                                                          |
/// |     1005     |    404   |    Not Found                 |   One of the required resources does not exist.                                                                            |
/// |     1006     |    409   |    Conflict                  |   A transaction with the same order ID already exists.                                                                     |
/// |     1007     |    402   |    Payment Required          |   The transfer of funds between a bank or card account and the Openpay account was not accepted.                           |
/// |     1008     |    423   |    Locked                    |   One of the accounts required in the request is disabled.                                                                 |
/// |     1009     |    413   |    Request Entity too large  |   The request body is too large.                                                                                           |
/// |     1010     |    403   |    Forbidden                 |   The public key is being used to make a call that requires the private key, or the private key is being used from Dart.   |
///
///
/// ### Storage Error Codes
///
/// | Openpay Code | HTTP Code|        Error HTTP            |                                     Cause                                        |
/// |-------------:|---------:|:----------------------------:|----------------------------------------------------------------------------------|
/// |     2001     |    409   |    Conflict                  |   The bank account with this CLABE is already registered to the customer.        |
/// |     2002     |    409   |    Conflict                  |   The card with this number is already registered to the customer.               |
/// |     2003     |    409   |    Conflict                  |   The customer with this external identifier (External ID) already exists.       |
/// |     2004     |    422   |    Unprocessable Entity      |   The check digit of the card number is invalid according to the Luhn algorithm. |
/// |     2005     |    400   |    Bad Request               |   The expiration date of the card is before the current date.                    |
/// |     2006     |    400   |    Bad Request               |   The card security code (CVV2) was not provided.                                |
/// |     2007     |    412   |    Precondition Failed       |   The card number is a test card and can only be used in Sandbox.                |
/// |     2008     |    412   |    Precondition Failed       |   The queried card is not valid for points.                                      |
/// |     2009     |    412   |    Precondition Failed       |   The card security code (CVV2) is invalid.                                      |
///
///
/// ### Card Error Codes
///
/// | Openpay Code | HTTP Code|        Error HTTP            |                                   Cause                                |
/// |-------------:|---------:|:----------------------------:|------------------------------------------------------------------------|
/// |     3001     |    402   |    Payment Required          |    The card was declined.                                              |
/// |     3002     |    402   |    Payment Required          |    The card has expired.                                               |
/// |     3003     |    402   |    Payment Required          |    The card does not have sufficient funds.                            |
/// |     3004     |    402   |    Payment Required          |    The card has been identified as a stolen card.                      |
/// |     3005     |    402   |    Payment Required          |    The card has been identified as a fraudulent card.                  |
/// |     3006     |    412   |    Precondition Failed       |    The operation is not allowed for this customer or transaction.      |
/// |     3008     |    412   |    Precondition Failed       |    The card is not supported for online transactions.                  |
/// |     3009     |    402   |    Payment Required          |    The card was reported as lost.                                      |
/// |     3010     |    402   |    Payment Required          |    The bank has restricted the card.                                   |
/// |     3011     |    402   |    Payment Required          |    The bank has requested that the card be held. Contact the bank.     |
/// |     3012     |    412   |    Precondition Failed       |    Authorization must be requested from the bank to make this payment. |
///
///
/// ### Account Error Codes
///
/// | Openpay Code | HTTP Code|        Error HTTP            |                           Cause                       |
/// |-------------:|---------:|:----------------------------:|-------------------------------------------------------|
/// |     4001     |    412   |     Precondition Failed      |   The Openpay account does not have sufficient funds. |
///
///
class OpenpayError {
  OpenpayError({
    required this.category,
    required this.description,
    required this.httpCode,
    required this.errorCode,
    required this.requestId,
    this.fraudRules,
  });

  /// [category] Indicates the type of error.
  ///
  /// *request:* Indicates an error caused by data sent by the client.
  /// For example, an invalid request, an attempted transaction without
  /// funds, or a transfer to an account that does not exist.
  ///
  /// *internal:* Indicates an error on the Openpay side, and it will
  /// happen very rarely.
  ///
  /// *gateway:* Indicates an error during the transaction of funds
  /// from a card to the Openpay account or from the account to a bank
  /// or card.
  final String category;

  /// Error description.
  final String description;

  /// HTTP error code of the response.
  final int httpCode;

  /// The Openpay error code indicating the problem that occurred.
  final int errorCode;

  /// Request identifier.
  final String requestId;

  /// Match list of rules defined for fraud detection.
  final List<String>? fraudRules;

  /// Copy the current instance of [OpenpayError] with the new values.
  /// If the value is null, it will be the same as the current instance.
  /// Returns a new instance of [OpenpayError].
  OpenpayError copyWith({
    String? category,
    String? description,
    int? httpCode,
    int? errorCode,
    String? requestId,
    List<String>? fraudRules,
  }) =>
      OpenpayError(
        category: category ?? this.category,
        description: description ?? this.description,
        httpCode: httpCode ?? this.httpCode,
        errorCode: errorCode ?? this.errorCode,
        requestId: requestId ?? this.requestId,
        fraudRules: fraudRules ?? this.fraudRules,
      );

  /// Convert the current instance of [OpenpayError] to a JSON object.
  factory OpenpayError.fromJson(Map<String, dynamic> json) => OpenpayError(
        category: json["category"],
        description: json["description"],
        httpCode: json["http_code"],
        errorCode: json["error_code"],
        requestId: json["request_id"] ?? '',
        fraudRules: json["fraud_rules"] != null
            ? List<String>.from(json["fraud_rules"].map((x) => x))
            : [],
      );

  /// Convert the current instance of [OpenpayError] to a JSON object.
  Map<String, dynamic> get toJson => {
        "category": category,
        "description": description,
        "http_code": httpCode,
        "error_code": errorCode,
        "request_id": requestId,
        "fraud_rules": fraudRules == null
            ? []
            : List<dynamic>.from(fraudRules!.map((x) => x)),
      };
}
