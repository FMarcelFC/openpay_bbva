import 'dart:convert';

import 'package:http/http.dart';

import '../enums/country.dart';
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

  /// The [getToken] method is used to get a token from a card.
  /// It returns a [Future] of [TokenOpenpay].
  Future<TokenOpenpay> getToken(CardInformation card) async {
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$publicApiKey:'));
    final response = await post(
      Uri.parse('$_merchantBaseUrl/tokens'),
      headers: {
        'Content-type': 'application/json',
        'Authorization': basicAuth,
        'Accept': 'application/json',
      },
      body: jsonEncode(card.tokenNecesary),
    );
    if (response.statusCode == 201) {
      return TokenOpenpay.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}, ${response.body}');
    }
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
