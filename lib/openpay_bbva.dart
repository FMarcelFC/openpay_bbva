import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:openpay_bbva/openpay_api.dart';

import 'src/enums/country.dart';

export 'package:openpay_bbva/src/enums/country.dart';
export 'package:openpay_bbva/src/http/openpay_api.dart';
export 'package:openpay_bbva/src/models/card_information.dart';
export 'package:openpay_bbva/src/platforms/openpay_bbva.dart';

/// [OpenpayBBVA] is the class that allows you to get the device ID and card token from Openpay needed for your card payments.
@Deprecated('Use OpenpayBBVA instead')
class DepOpenpayBBVA extends Openpay {
  @visibleForTesting

  /// Both [merchantId] as [publicApiKey], are obtained from the homepage of your account on the Openpay (http://www.openpay.mx/) site.
  final String merchantId;
  final String publicApiKey;

  /// [productionMode] true if production, false if debugging.
  final bool productionMode;

  /// Use the [Country] class which has the options of Colombia, Perú and Mexico (by default). For example: [Country : Country.Mexico]
  Country country;

  /// The [_methodChannel] connects to the Openpay libraries to use native code.
  static const _methodChannel = MethodChannel('openpay_bbva');

  /// [OpenpayBBVA] is the class that allows you to get the device ID and card token from Openpay needed for your card payments.
  DepOpenpayBBVA(
    this.merchantId,
    this.publicApiKey, {
    required this.productionMode,
    this.country = Country.MX,
  }) : super(merchantId, publicApiKey,
            isSandboxMode: !productionMode, country: country);

  /// The [getDeviceID] method uses the [merchantId] and [publicApiKey] provided by Openpay to get the Device Session ID and return it in the [deviceID] variable as a String.
  ///
  /// This is only implemented for iOS and Android.
  Future<String?> getDeviceID() async {
    try {
      final deviceID =
          await _methodChannel.invokeMethod<String>('getDeviceId', {
        'MERCHANT_ID': merchantId,
        'API_KEY': publicApiKey,
        'productionMode': productionMode,
        'country': country.name,
      });
      return deviceID; // Returns the Device Session ID.
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  /// The [getCardToken] method uses the card information to generate a card token through the Openpay APIs.
  ///
  /// The cardholder's [name] ex: 'Jose Perez Cruz'.
  ///
  /// The card's [number] without spaces ex: '411111111111'.
  ///
  /// The card's expiration [month] ex: '11'
  ///
  /// The card's expiration [year] ex: '22'
  ///
  /// The card's [cvv] found in the back of the card, ex: '111'
  Future<String?> getCardToken(String name, String cardNumber, String month,
      String year, String cvv) async {
    try {
      CardInfo card = CardInfo(cardNumber, name, year, month, cvv);
      TokenInfo token = await createToken(card);
      return token.id; // Returns the card token.
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
