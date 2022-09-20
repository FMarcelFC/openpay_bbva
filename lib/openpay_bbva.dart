import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:openpay/openpay.dart';

/// [OpenpayBBVA] is the class that allows you to get the device ID and card token from Openpay needed for your card payments.
class OpenpayBBVA extends Openpay {
  @visibleForTesting

  /// Both [MERCHANT_ID] as [PUBLIC_API_KEY], are obtained from the homepage of your account on the Openpay (http://www.openpay.mx/) site.
  final String MERCHANT_ID;
  final String PUBLIC_API_KEY;

  /// [productionMode] true if production, false if debugging.
  final bool productionMode;

  /// Use the [OpCountry] class which has the options of Colombia, Perú and Mexico (by default). For example: [opCountry : OpCountry.COL]
  OpCountry? opCountry;

  /// The [_methodChannel] connects to the Openpay libraries to use native code.
  static const _methodChannel = MethodChannel('openpay_bbva');

  /// [OpenpayBBVA] is the class that allows you to get the device ID and card token from Openpay needed for your card payments.
  OpenpayBBVA(this.MERCHANT_ID, this.PUBLIC_API_KEY,
      {required this.productionMode, this.opCountry = OpCountry.Mexico})
      : super(MERCHANT_ID, PUBLIC_API_KEY,
            isSandboxMode: !productionMode,
            country: opCountry == OpCountry.Colombia
                ? Country.Colombia
                : Country.Mexico);

  /// Get the selected [opcountry].
  String? get opcountry => _countries[this.opCountry];

  /// The [getDeviceID] method uses the [MERCHANT_ID] and [PUBLIC_API_KEY] provided by Openpay to get the Device Session ID and return it in the [deviceID] variable as a String.
  ///
  /// This is only implemented for iOS and Android.
  Future<String?> getDeviceID() async {
    try {
      final deviceID =
          await _methodChannel.invokeMethod<String>('getDeviceId', {
        'MERCHANT_ID': MERCHANT_ID,
        'API_KEY': PUBLIC_API_KEY,
        'productionMode': productionMode,
        'country': this.opcountry
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

/// [OpCountry] is the class used to select your country in the Openpay instance.
const Map<OpCountry, String> _countries = {
  OpCountry.Colombia: 'Colombia',
  OpCountry.Mexico: 'Mexico'
};

enum OpCountry { Colombia, Mexico }
