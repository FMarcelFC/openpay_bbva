import 'card_information.dart';

/// [ToeknOpenpay] is the class that allows you to get the
/// device ID and card token from Openpay needed for your
/// card payments.
class TokenOpenpay {
  TokenOpenpay({
    required this.id,
    required this.card,
  });

  /// The [id] is the token id.
  final String id;

  /// The [card] is the card information.
  final CardInformation card;

  factory TokenOpenpay.fromJson(Map<String, dynamic> json) => TokenOpenpay(
        id: json["id"],
        card: CardInformation.fromJson(json["card"]),
      );

  Map<String, dynamic> get toJson => {
        "id": id,
        "card": card.toJson,
      };

  @override
  String toString() => toJson.toString();
}
