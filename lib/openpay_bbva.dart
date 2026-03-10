/// A Flutter plugin for tokenizing card payments via the Openpay BBVA platform.
///
/// Supports iOS and Android for native Device Session ID retrieval, and all
/// platforms (Web, Windows, macOS, Linux) for card tokenization via HTTP.
///
/// ## Quick start
///
/// ```dart
/// import 'package:openpay_bbva/openpay_bbva.dart';
///
/// final openpay = OpenpayBBVA(
///   merchantId: 'YOUR_MERCHANT_ID',
///   publicApiKey: 'YOUR_PUBLIC_API_KEY',
///   productionMode: false,
///   country: Country.MX,
/// );
///
/// // Get the device session ID (iOS / Android only)
/// final deviceId = await openpay.getDeviceID();
///
/// // Tokenize a card
/// final token = await openpay.getCardToken(
///   CardInformation(
///     holderName: 'John Doe',
///     cardNumber: '4111111111111111',
///     expirationMonth: '12',
///     expirationYear: '25',
///     cvv2: '123',
///   ),
/// );
/// ```
///
/// See also:
/// - [OpenpayBBVA] — main entry point.
/// - [CardInformation] — card data model.
/// - [TokenOpenpay] — token response model.
/// - [OpenpayExceptionError] — structured error model.
/// - [Country] — supported countries.
library openpay_bbva;

export 'package:openpay_bbva/src/enums/country.dart';
export 'package:openpay_bbva/src/error/openpay_exception.dart';
export 'package:openpay_bbva/src/http/openpay_api.dart';
export 'package:openpay_bbva/src/models/address.dart';
export 'package:openpay_bbva/src/models/card_information.dart';
export 'package:openpay_bbva/src/models/token_openpay.dart';
export 'package:openpay_bbva/src/platforms/openpay_bbva.dart';
