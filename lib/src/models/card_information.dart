// To parse a JSON string into a CardInformation instance:
//
//     final card = cardInformationFromJson(jsonString);

import 'dart:convert';

import 'address.dart';

/// Parses a [CardInformation] instance from a raw JSON string.
CardInformation cardInformationFromJson(String str) =>
    CardInformation.fromJson(json.decode(str));

/// Serializes a [CardInformation] instance to a JSON string.
String cardInformationToJson(CardInformation data) => json.encode(data.toJson);

/// Represents the full set of card data used for tokenization and storage
/// within the Openpay BBVA platform.
///
/// Required fields for tokenization are [holderName], [cardNumber],
/// [expirationMonth], [expirationYear], and [cvv2]. All other fields
/// are populated by Openpay in API responses.
///
/// ## Example — creating a card for tokenization
///
/// ```dart
/// final card = CardInformation(
///   holderName: 'John Doe',
///   cardNumber: '4111111111111111',
///   expirationMonth: '12',
///   expirationYear: '25',
///   cvv2: '123',
/// );
///
/// final token = await openpay.getCardToken(card);
/// ```
///
/// ## Example — creating a card with a billing address
///
/// ```dart
/// final card = CardInformation(
///   holderName: 'John Doe',
///   cardNumber: '4111111111111111',
///   expirationMonth: '12',
///   expirationYear: '25',
///   cvv2: '123',
///   address: Address(
///     line1: '123 Main St',
///     line2: 'Apt 4B',
///     line3: 'Centro',
///     city: 'Mexico City',
///     state: 'CDMX',
///     postalCode: '06600',
///     countryCode: 'MX',
///   ),
/// );
/// ```
class CardInformation {
  /// Creates a [CardInformation] instance.
  ///
  /// [holderName], [cardNumber], [expirationMonth], [expirationYear], and
  /// [cvv2] are required for tokenization. All other parameters are optional
  /// and are typically populated from API responses.
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

  /// Unique card identifier assigned by Openpay after the card is saved.
  ///
  /// Empty when constructing a card locally for tokenization.
  final String id;

  /// Date and time the card was created, in ISO 8601 format.
  ///
  /// `null` when constructing a card locally.
  final DateTime? creationDate;

  /// Full name of the cardholder, as it appears on the card.
  final String holderName;

  /// Card number. Can be 16 or 19 digits.
  ///
  /// In API responses, only the last 4 digits are returned.
  final String cardNumber;

  /// Card Verification Value (CVV2 / CVC), as printed on the back of the card.
  ///
  /// Typically 3 digits; 4 digits for American Express.
  /// In API responses, this field is masked as `'XXX'`.
  final String cvv2;

  /// Two-digit expiration month as it appears on the card (e.g., `'01'`–`'12'`).
  final String expirationMonth;

  /// Two-digit expiration year as it appears on the card (e.g., `'25'` for 2025).
  final String expirationYear;

  /// Optional billing address associated with the cardholder.
  final Address? address;

  /// Whether this card can be used to create charges.
  ///
  /// `null` when the card has not yet been saved through Openpay.
  final bool? allowsCharges;

  /// Whether this card can receive payouts.
  ///
  /// `null` when the card has not yet been saved through Openpay.
  final bool? allowsPayouts;

  /// Card network brand. Possible values: `visa`, `mastercard`, `carnet`,
  /// `american express`.
  final String brand;

  /// Card funding type. Possible values: `debit`, `credit`, `cash`, etc.
  final String type;

  /// Name of the bank that issued the card.
  final String bankName;

  /// Code of the bank that issued the card.
  final String bankCode;

  /// Identifier of the customer this card belongs to.
  ///
  /// `null` when the card is stored at the merchant level.
  final String? customerId;

  /// Whether this card supports payment with loyalty points.
  final bool pointsCard;

  /// Returns a copy of this [CardInformation] with the given fields replaced.
  ///
  /// Fields that are not provided retain their current values.
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

  /// Creates a [CardInformation] from a JSON map returned by the Openpay API.
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

  /// Serializes this [CardInformation] to a JSON-serializable map.
  ///
  /// Includes all fields. Use [tokenNecessary] or [saveCardNecessary] for
  /// request-specific payloads.
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

  /// Minimal JSON payload required by the Openpay **token** endpoint.
  ///
  /// Includes [cardNumber], [holderName], [expirationYear], [expirationMonth],
  /// [cvv2], and optionally [address].
  Map<String, dynamic> get tokenNecessary => {
        "card_number": cardNumber,
        "holder_name": holderName,
        "expiration_year": expirationYear,
        "expiration_month": expirationMonth,
        "cvv2": cvv2,
        "address": address == null ? null : addressToJson(address!),
      };

  /// Minimal JSON payload required by the Openpay **save card** endpoint.
  ///
  /// Includes [cardNumber], [holderName], [expirationYear], [expirationMonth],
  /// and [cvv2]. The `device_session_id` is added separately by [OpenpayApi.saveCard].
  Map<String, dynamic> get saveCardNecessary => {
        "card_number": cardNumber,
        "holder_name": holderName,
        "expiration_year": expirationYear,
        "expiration_month": expirationMonth,
        "cvv2": cvv2,
      };

  @override
  String toString() => toJson.toString();
}
