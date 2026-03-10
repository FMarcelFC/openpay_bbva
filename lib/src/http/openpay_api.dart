import 'dart:convert';

import 'package:http/http.dart';

import '../enums/country.dart';
import '../error/openpay_exception.dart';
import '../models/card_information.dart';
import '../models/token_openpay.dart';

/// Low-level HTTP client for the Openpay REST API.
///
/// Handles authentication, URL resolution (sandbox vs. production, by country),
/// and request/response serialization. This class is extended by [OpenpayBBVA],
/// which adds native platform support.
///
/// You can use [OpenpayApi] directly if you only need HTTP-based card
/// operations (all platforms), or use [OpenpayBBVA] for the full feature set
/// including the Device Session ID on mobile.
///
/// ## Supported endpoints
///
/// | Method       | Endpoint          | Description                          |
/// |:-------------|:------------------|:-------------------------------------|
/// | [getToken]   | `POST /tokens`    | Tokenize a card                      |
/// | [saveCard]   | `POST /cards`     | Save a card to the merchant account  |
///
/// ## Base URLs by country and environment
///
/// | Country | Sandbox                           | Production               |
/// |:--------|:----------------------------------|:-------------------------|
/// | MX      | `sandbox-api.openpay.mx`          | `api.openpay.mx`         |
/// | CO      | `sandbox-api.openpay.co`          | `api.openpay.co`         |
/// | PE      | `sandbox-api.openpay.pe`          | `api.openpay.pe`         |
class OpenpayApi {
  /// Creates an [OpenpayApi] instance.
  ///
  /// - [merchantId]: Your Openpay merchant identifier.
  /// - [publicApiKey]: Your public API key. **Never use your private key here.**
  /// - [isSandboxMode]: When `true`, requests target the sandbox environment.
  ///   Defaults to `false`.
  /// - [country]: The country associated with your Openpay account.
  ///   Defaults to [Country.MX].
  OpenpayApi({
    required this.merchantId,
    required this.publicApiKey,
    this.isSandboxMode = false,
    this.country = Country.MX,
  });

  /// Whether the sandbox (test) environment is active.
  ///
  /// When `true`, no real transactions are processed.
  final bool isSandboxMode;

  /// Your Openpay merchant identifier.
  final String merchantId;

  /// Your Openpay public API key.
  ///
  /// This key is safe to include in client-side code. Never use your private
  /// key in Flutter applications.
  final String publicApiKey;

  /// The country whose Openpay endpoints will be used.
  final Country country;

  /// The base URL for the current environment and country.
  ///
  /// Resolves to the sandbox or production URL depending on [isSandboxMode].
  String get baseUrl => isSandboxMode
      ? _sandboxUrls[country]!
      : _productionUrls[country]!;

  /// The merchant-scoped base URL (`{baseUrl}/v1/{merchantId}`).
  String get _merchantBaseUrl => '$baseUrl/v1/$merchantId';

  /// Tokenizes a card and returns a [TokenOpenpay] containing the token ID
  /// and partial card metadata.
  ///
  /// Sends the minimum required card fields ([CardInformation.tokenNecessary])
  /// to the `POST /tokens` endpoint. The token ID can then be used to create
  /// a charge via the Openpay server-side API.
  ///
  /// > **Note:** Once tokenized, the raw card number and CVV cannot be
  /// > retrieved — Openpay encrypts and stores them securely.
  ///
  /// Throws an [OpenpayExceptionError] if the API returns a non-201 response.
  ///
  /// ```dart
  /// final token = await openpayApi.getToken(card);
  /// print(token.id); // Use this ID to create a charge
  /// ```
  Future<TokenOpenpay> getToken(CardInformation card) async {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$publicApiKey:'))}';

    final response = await post(
      Uri.parse('$_merchantBaseUrl/tokens'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
        'Accept': 'application/json',
      },
      body: jsonEncode(card.tokenNecessary),
    );

    if (response.statusCode == 201) {
      return tokenOpenpayFromJson(response.body);
    }

    throw OpenpayExceptionError(error: openpayErrorFromJson(response.body));
  }

  /// Saves a card to your Openpay merchant account and returns the stored
  /// [CardInformation] with its assigned [CardInformation.id].
  ///
  /// The saved card can later be used to create charges or payouts using its
  /// [CardInformation.id], without requiring the raw card data again.
  ///
  /// > **Note:** All cards are validated at save time via a $10.00 MXN
  /// > authorization that is immediately reversed.
  ///
  /// > **Note:** Once saved, the card number and CVV cannot be retrieved.
  ///
  /// - [card]: The card to save. Only [CardInformation.saveCardNecessary]
  ///   fields are sent.
  /// - [deviceSessionId]: The Device Session ID obtained via
  ///   [OpenpayBBVA.getDeviceID]. Required for anti-fraud validation.
  ///
  /// Throws an [OpenpayExceptionError] if the API returns a non-201 response.
  ///
  /// ```dart
  /// final saved = await openpayApi.saveCard(
  ///   card: card,
  ///   deviceSessionId: deviceId,
  /// );
  /// print(saved.id); // Store this ID for future charges
  /// ```
  Future<CardInformation> saveCard({
    required CardInformation card,
    required String deviceSessionId,
  }) async {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$publicApiKey:'))}';

    final response = await post(
      Uri.parse('$_merchantBaseUrl/cards'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
        'Accept': 'application/json',
      },
      body: jsonEncode({
        ...card.saveCardNecessary,
        'device_session_id': deviceSessionId,
      }),
    );

    if (response.statusCode == 201) {
      return cardInformationFromJson(response.body);
    }

    throw OpenpayExceptionError(error: openpayErrorFromJson(response.body));
  }

  /// Sandbox API base URLs indexed by [Country].
  static const Map<Country, String> _sandboxUrls = {
    Country.MX: 'https://sandbox-api.openpay.mx',
    Country.CO: 'https://sandbox-api.openpay.co',
    Country.PE: 'https://sandbox-api.openpay.pe',
  };

  /// Production API base URLs indexed by [Country].
  static const Map<Country, String> _productionUrls = {
    Country.MX: 'https://api.openpay.mx',
    Country.CO: 'https://api.openpay.co',
    Country.PE: 'https://api.openpay.pe',
  };
}
