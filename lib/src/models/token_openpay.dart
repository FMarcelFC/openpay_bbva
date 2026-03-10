import 'dart:convert';

import 'card_information.dart';

/// Parses a [TokenOpenpay] instance from a raw JSON string.
TokenOpenpay tokenOpenpayFromJson(String str) =>
    TokenOpenpay.fromJson(json.decode(str));

/// Serializes a [TokenOpenpay] instance to a JSON string.
String tokenOpenpayToJson(TokenOpenpay data) => json.encode(data.toJson);

/// Represents the token response returned by the Openpay API after a
/// successful card tokenization request.
///
/// A [TokenOpenpay] contains the [id] you must supply when creating a charge,
/// along with partial (non-sensitive) [card] information to confirm which card
/// was tokenized.
///
/// ## Example
///
/// ```dart
/// final token = await openpay.getCardToken(card);
/// print(token); // The token ID string
/// ```
///
/// See also:
/// - [OpenpayBBVA.getCardToken] — convenience method that returns only the [id].
/// - [OpenpayApi.getToken] — returns the full [TokenOpenpay] object.
class TokenOpenpay {
  /// Creates a [TokenOpenpay] instance.
  TokenOpenpay({
    required this.id,
    required this.card,
  });

  /// The unique token identifier returned by Openpay.
  ///
  /// Use this value when creating a charge via the Openpay API.
  final String id;

  /// Partial, non-sensitive data of the card associated with this token.
  ///
  /// The card number and CVV are masked; only metadata such as [CardInformation.brand],
  /// [CardInformation.bankName], and [CardInformation.holderName] are included.
  final CardInformation card;

  /// Creates a [TokenOpenpay] from a JSON map returned by the Openpay API.
  factory TokenOpenpay.fromJson(Map<String, dynamic> json) => TokenOpenpay(
        id: json["id"],
        card: CardInformation.fromJson(json["card"]),
      );

  /// Converts this [TokenOpenpay] instance to a JSON-serializable map.
  Map<String, dynamic> get toJson => {
        "id": id,
        "card": cardInformationToJson(card),
      };

  @override
  String toString() => toJson.toString();
}
