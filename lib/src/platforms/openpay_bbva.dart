import 'package:flutter/services.dart';

import '../enums/country.dart';
import '../http/openpay_api.dart';
import '../models/card_information.dart';

/// OpenpayBBVA is a class that contains the API urls
class OpenpayBBVA extends OpenpayApi {
  /// Both [merchantId] as [publicApiKey], are obtained from the
  /// homepage of your account on the Openpay
  /// (http://www.openpay.mx/) site.
  OpenpayBBVA({
    required String merchantId,
    required String publicApiKey,
    bool productionMode = false,
    Country country = Country.MX,
  }) : super(
          merchantId: merchantId,
          publicApiKey: publicApiKey,
          isSandboxMode: !productionMode,
          country: country,
        );

  /// The [getDeviceID] method uses the [merchantId] and
  /// [publicApiKey] provided by Openpay to get the Device
  /// Session ID and return it in the [deviceID] variable
  /// as a String.
  ///
  /// This is only implemented for iOS and Android.
  Future<String?> getDeviceID() async {
    try {
      final deviceID = await _methodChannel.invokeMethod<String>(
        'getDeviceId',
        {
          'MERCHANT_ID': merchantId,
          'API_KEY': publicApiKey,
          'productionMode': !this.isSandboxMode,
          'country': this.country.name,
        },
      );
      return deviceID;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  /// The [getCardToken] method uses the [merchantId] and
  /// [publicApiKey] provided by Openpay to get the Card
  /// Token and return it in the [cardToken] variable
  /// as a String.
  Future<String> getCardToken(CardInformation card) async =>
      (await getToken(card)).id;

  /// The [_methodChannel] connects to the Openpay libraries to
  /// use native code.
  static const _methodChannel = MethodChannel('openpay_bbva');
}
