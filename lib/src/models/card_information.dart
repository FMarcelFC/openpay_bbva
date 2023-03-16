// To parse this JSON data, do
//
//     final cardInformation = cardInformationFromJson(jsonString);

import 'dart:convert';

import 'address.dart';

/// Card Information from json
///
/// Returns a [CardInformation] instance from a json string
CardInformation cardInformationFromJson(String str) =>
    CardInformation.fromJson(json.decode(str));

/// Card Information to json
///
/// Returns a string representation of a [CardInformation] instance
String cardInformationToJson(CardInformation data) => json.encode(data.toJson);

/// Card Information representation class
class CardInformation {
  CardInformation({
    this.id = '',
    this.creationDate,
    required this.holderName,
    required this.cardNumber,
    required this.cvv2,
    required this.expirationMonth,
    required this.expirationYear,
    this.address,
    this.allowsCharges,
    this.allowsPayouts,
    this.brand = '',
    this.type = '',
    this.bankName = '',
    this.bankCode = '',
    this.customerId,
    this.pointsCard = false,
  });

  /// Unique card identifier.
  final String id;

  ///Date and time the card was created in ISO 8601 format
  final DateTime? creationDate;

  /// Name of the cardholder.
  final String holderName;

  /// Card number, can be 16 or 19 digits.
  final String cardNumber;

  /// Security code as it appears on the back of the card.
  /// Usually 3 digits.
  final String cvv2;

  /// Expiration month as it appears on the card.
  final String expirationMonth;

  /// Expiration year as it appears on the card.
  final String expirationYear;

  /// Billing address of the cardholder.
  final Address? address;

  /// Lets you know if charges can be made to the card.
  final bool? allowsCharges;

  /// Lets you know if you can send payments to the card.
  final bool? allowsPayouts;

  /// Card brand: [visa], [mastercard], [carnet] or
  /// [american express].
  final String brand;

  /// Card type: debit, credit, cash, etc.
  final String type;

  /// Name of the issuing bank.
  final String bankName;

  /// Code of the issuing bank.
  final String bankCode;

  /// Identifier of the customer to which the card belongs.
  /// If the card is at the merchant level, this value will
  /// be null.
  final String? customerId;

  /// Indicates if the card supports payment with points.
  final bool pointsCard;

  /// Returns a copy of this [CardInformation] instance
  /// with the given fields replaced with the new values.
  /// If a field is null, the current value will be used.
  /// If a field is not null, the current value will be replaced.
  /// If a field is not null and the current value is null,
  /// the current value will be replaced.
  CardInformation copyWith({
    String? id,
    DateTime? creationDate,
    String? holderName,
    String? cardNumber,
    String? cvv2,
    String? expirationMonth,
    String? expirationYear,
    Address? address,
    bool? allowsCharges,
    bool? allowsPayouts,
    String? brand,
    String? type,
    String? bankName,
    String? bankCode,
    String? customerId,
    bool? pointsCard,
  }) =>
      CardInformation(
        id: id ?? this.id,
        creationDate: creationDate ?? this.creationDate,
        holderName: holderName ?? this.holderName,
        cardNumber: cardNumber ?? this.cardNumber,
        cvv2: cvv2 ?? this.cvv2,
        expirationMonth: expirationMonth ?? this.expirationMonth,
        expirationYear: expirationYear ?? this.expirationYear,
        address: address ?? this.address,
        allowsCharges: allowsCharges ?? this.allowsCharges,
        allowsPayouts: allowsPayouts ?? this.allowsPayouts,
        brand: brand ?? this.brand,
        type: type ?? this.type,
        bankName: bankName ?? this.bankName,
        bankCode: bankCode ?? this.bankCode,
        customerId: customerId ?? this.customerId,
        pointsCard: pointsCard ?? this.pointsCard,
      );

  /// Return a [CardInformation] instance from a json map
  factory CardInformation.fromJson(Map<String, dynamic> json) =>
      CardInformation(
        id: json["id"] ?? '',
        creationDate: json["creation_date"] == null
            ? null
            : DateTime.parse(json["creation_date"]),
        holderName: json["holder_name"],
        cardNumber: json["card_number"],
        cvv2: json["cvv2"] ?? 'XXX',
        expirationMonth: json["expiration_month"],
        expirationYear: json["expiration_year"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        allowsCharges: json["allows_charges"],
        allowsPayouts: json["allows_payouts"],
        brand: json["brand"] ?? '',
        type: json["type"] ?? '',
        bankName: json["bank_name"] ?? '',
        bankCode: json["bank_code"] ?? '',
        customerId: json["customer_id"],
        pointsCard: json["points_card"] ?? false,
      );

  /// Returns a json map representation of a [CardInformation] instance
  /// with the given fields replaced with the new values.
  Map<String, dynamic> get toJson => {
        "id": id,
        "type": type,
        "brand": brand,
        "card_number": cardNumber,
        "holder_name": holderName,
        "expiration_year": expirationYear,
        "expiration_month": expirationMonth,
        "allows_charges": allowsCharges,
        "allows_payouts": allowsPayouts,
        "creation_date":
            creationDate == null ? '' : creationDate!.toIso8601String(),
        "bank_name": bankName,
        "bank_code": bankCode,
        "customer_id": customerId ?? '',
        "points_card": pointsCard,
        "address": address == null ? null : addressToJson(address!),
      };

  /// Returns a json map from a [CardInformation] instance
  Map<String, dynamic> get tokenNecesary => {
        "card_number": cardNumber,
        "holder_name": holderName,
        "expiration_year": expirationYear,
        "expiration_month": expirationMonth,
        "cvv2": cvv2,
        "address": address == null ? null : addressToJson(address!),
      };

  /// Returns a json map from a [CardInformation] instance
  Map<String, dynamic> get saveCardNecesary => {
        "card_number": cardNumber,
        "holder_name": holderName,
        "expiration_year": expirationYear,
        "expiration_month": expirationMonth,
        "cvv2": cvv2,
      };

  /// Returns a string representation of a [CardInformation] instance
  @override
  String toString() => toJson.toString();
}
