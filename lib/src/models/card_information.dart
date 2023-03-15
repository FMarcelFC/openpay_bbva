/// Card Information representation class
class CardInformation {
  CardInformation({
    required this.holderName,
    required this.cardNumber,
    required this.expirationYear,
    required this.expirationMonth,
    this.cvv2,
    this.brand,
    this.creationDate,
  });

  /// Card holder name
  final String holderName;

  /// Card number
  final String cardNumber;

  /// Card expiration year
  final int expirationYear;

  /// Card expiration month
  final int expirationMonth;

  /// Card cvv2
  final String? cvv2;

  /// Card brand
  final String? brand;

  /// Card creation date
  final String? creationDate;

  /// Creates a [CardInformation] instance from a json map
  factory CardInformation.fromJson(Map<String, dynamic> json) =>
      CardInformation(
        cardNumber: json["card_number"],
        holderName: json["holder_name"],
        expirationYear: int.parse(json["expiration_year"]),
        expirationMonth: int.parse(json["expiration_month"]),
        cvv2: json["cvv2"],
        brand: json["brand"],
        creationDate: json["creation_date"],
      );

  /// Returns a json map from a [CardInformation] instance
  Map<String, dynamic> get tokenNecesary => {
        "card_number": cardNumber.toString(),
        "holder_name": holderName,
        "expiration_year": expirationYear.toString(),
        "expiration_month": expirationMonth.toString(),
        "cvv2": cvv2 != null ? cvv2.toString() : null,
      };

  /// Returns a json map from a [CardInformation] instance
  Map<String, dynamic> get toJson => {
        "card_number": cardNumber.toString(),
        "holder_name": holderName,
        "expiration_year": expirationYear.toString(),
        "expiration_month": expirationMonth.toString(),
        "cvv2": cvv2 != null ? cvv2.toString() : null,
        "brand": brand,
        "creation_date": creationDate,
      };

  /// Returns a string representation of a [CardInformation] instance
  @override
  String toString() => toJson.toString();
}
