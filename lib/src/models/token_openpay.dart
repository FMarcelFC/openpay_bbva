import 'dart:convert';

import 'card_information.dart';

/// Token Openpay from json
///
/// Returns a [TokenOpenpay] instance from a json string
TokenOpenpay tokenOpenpayFromJson(String str) =>
    TokenOpenpay.fromJson(json.decode(str));

/// Token Openpay to json
///
/// Returns a string representation of a [TokenOpenpay] instance
String tokenOpenpayToJson(TokenOpenpay data) => json.encode(data.toJson);

/// [ToeknOpenpay] is the class that allows you to get the
/// device ID and card token from Openpay needed for your
/// card payments.
class TokenOpenpay {
  TokenOpenpay({
    required this.id,
    required this.card,
  });

  /// [Token identifier]. This is the one you should use to
  /// later make a charge.
  final String id;

  /// Data of the [card] associated with the token.
  final CardInformation card;

  /// The TokenOpenpay.fromJson method is used to create a [TokenOpenpay]
  /// object from a json.
  factory TokenOpenpay.fromJson(Map<String, dynamic> json) => TokenOpenpay(
        id: json["id"],
        card: CardInformation.fromJson(json["card"]),
      );

  /// The [toJson] method is used to convert a [TokenOpenpay] object
  /// to a json.
  Map<String, dynamic> get toJson => {
        "id": id,
        "card": cardInformationToJson(card),
      };

  @override
  String toString() => toJson.toString();
}
