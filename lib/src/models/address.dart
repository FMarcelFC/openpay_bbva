// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);
import 'dart:convert';

/// AddressFromJson is a function that returns a Address instance
/// from a json string
Address addressFromJson(String str) => Address.fromJson(json.decode(str));

/// AddressToJson is a function that returns a json string
/// from a Address instance
String addressToJson(Address data) => json.encode(data.toJson);

/// Address is a class that contains the address information
/// of a card
class Address {
  Address({
    required this.line1,
    required this.line2,
    required this.line3,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.countryCode,
  });

  /// First line of the cardholder's address. Commonly used
  /// to indicate the street and exterior and interior number.
  final String line1;

  /// Second line of the cardholder's address. Commonly used
  /// to indicate condominium, suite or delegation.
  final String line2;

  /// Third line of the cardholder's address. Commonly used
  /// to indicate the colony.
  final String line3;

  /// State (Department) of the cardholder
  final String state;

  /// Cardholder City
  final String city;

  /// Cardholder Zip Code
  final String postalCode;

  /// Two-character cardholder country code in ISO_3166-1 format
  final String countryCode;

  /// Returns a copy of the current instance with the specified
  /// parameters
  Address copyWith({
    String? line1,
    String? line2,
    String? line3,
    String? state,
    String? city,
    String? postalCode,
    String? countryCode,
  }) =>
      Address(
        line1: line1 ?? this.line1,
        line2: line2 ?? this.line2,
        line3: line3 ?? this.line3,
        state: state ?? this.state,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
        countryCode: countryCode ?? this.countryCode,
      );

  /// Returns a string representation of a [Address] instance
  factory Address.fromJson(Map<String, dynamic> json) => Address(
        line1: json["line1"] ?? '',
        line2: json["line2"] ?? '',
        line3: json["line3"] ?? '',
        state: json["state"] ?? '',
        city: json["city"] ?? '',
        postalCode: json["postal_code"] ?? '',
        countryCode: json["country_code"] ?? '',
      );

  /// Returns a json map from a [Address] instance
  Map<String, dynamic> get toJson => {
        "line1": line1,
        "line2": line2,
        "line3": line3,
        "state": state,
        "city": city,
        "postal_code": postalCode,
        "country_code": countryCode,
      };
}
