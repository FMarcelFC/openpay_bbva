import 'dart:convert';

import 'package:http/http.dart';

import '../enums/country.dart';
import '../error/openpay_exception.dart';
import '../models/card_information.dart';
import '../models/token_openpay.dart';

/// OpenpayApi is a class that contains the API urls
class OpenpayApi {
  OpenpayApi({
    required this.merchantId,
    required this.publicApiKey,
    this.isSandboxMode = false,
    this.country = Country.MX,
  });

  /// The [isSandboxMode] is a boolean that indicates if the API
  /// will use the sandbox or production mode.
  /// False by default
  final bool isSandboxMode;

  /// The [merchantId] is the merchant id.
  final String merchantId;

  /// The [publicApiKey] is the public API Key.
  final String publicApiKey;

  /// The [country] is the country where the merchant is located.
  /// By default is [Country.MX].
  final Country country;

  /// The [baseUrl] is the base url of the API.
  String get baseUrl => isSandboxMode
      ? _sandboxUrls[this.country]!
      : _productionUrls[this.country]!;

  /// The [_merchantBaseUrl] is the base url of the API with the merchant id.
  String get _merchantBaseUrl => '$baseUrl/v1/$merchantId';

  /// To create a token in Openpay it is necessary to send the object with the
  /// information to register. Once the token is saved, the number and security
  /// code cannot be obtained since this information is encrypted.
  Future<TokenOpenpay> getToken(CardInformation card) async {
    /// The basic auth is the public API key encoded in base64.
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$publicApiKey:'));

    /// The [post] method is used to make a POST request to the API.
    final response = await post(
      /// The [Uri.parse] method is used to parse the url.
      Uri.parse('$_merchantBaseUrl/tokens'),

      /// The [headers] are the headers of the request.
      headers: {
        'Content-type': 'application/json',
        'Authorization': basicAuth,
        'Accept': 'application/json',
      },

      /// The [jsonEncode] method is used to encode the card information
      body: jsonEncode(card.tokenNecesary),
    );
    if (response.statusCode == 201) {
      /// Returns a [TokenOpenpay] if the request was successful.
      return tokenOpenpayFromJson(response.body);
      //TokenOpenpay.fromJson(jsonDecode(response.body));
    }

    /// Throws an [OpenpayExceptionError] if the request was not successful.
    throw OpenpayExceptionError(error: openpayErrorFromJson(response.body));
  }

  /// The card is registered for the merchant's account. Once the card is
  /// saved, the number and security code cannot be obtained.
  ///
  /// **Note:** All cards at the time of saving in Openpay are validated
  /// by making an authorization for $10.00 MXN which are returned at the
  /// time.
  ///
  /// When saving the card, an id will be generated that can be used to
  /// charge the card, send a card or simply obtain non-sensitive card
  /// information.
  Future<CardInformation> saveCard({
    required CardInformation card,
    required String deviceSessionId,
  }) async {
    /// The basic auth is the public API key encoded in base64.
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$publicApiKey:'));

    /// The [post] method is used to make a POST request to the API.
    final response = await post(
      /// The [Uri.parse] method is used to parse the url.
      Uri.parse('$_merchantBaseUrl/cards'),

      /// The [headers] are the headers of the request.
      headers: {
        'Content-type': 'application/json',
        'Authorization': basicAuth,
        'Accept': 'application/json',
      },

      /// The [jsonEncode] method is used to encode the card information
      body: jsonEncode({
        ...card.saveCardNecesary,

        /// The [deviceSessionId] is the id of the device.
        'device_session_id': deviceSessionId,
      }),
    );
    if (response.statusCode == 201) {
      /// Returns a [CardInformation] if the request was successful.
      return cardInformationFromJson(response.body);
    }

    /// Throws an [OpenpayExceptionError] if the request was not successful.
    throw OpenpayExceptionError(error: openpayErrorFromJson(response.body));
  }

  /// The [_sandboxUrls] is a map that contains the sandbox urls
  /// for each country.
  static const Map<Country, String> _sandboxUrls = {
    Country.MX: 'https://sandbox-api.openpay.mx',
    Country.CO: 'https://sandbox-api.openpay.co',
    Country.PE: 'https://sandbox-api.openpay.pe'
  };

  /// The [_productionUrls] is a map that contains the production urls
  /// for each country.
  static const Map<Country, String> _productionUrls = {
    Country.MX: 'https://api.openpay.mx',
    Country.CO: 'https://api.openpay.co',
    Country.PE: 'https://api.openpay.pe',
  };
}
