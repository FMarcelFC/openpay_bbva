import 'package:flutter/material.dart';
import 'dart:async';

import 'package:openpay_bbva/openpay_bbva.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _deviceID = '';
  String _token = '';
  final openpay = OpenpayBBVA(
    // Replace this with your MERCHANT_ID
    merchantId: "mliwbrm4orj40lhks7kv",
    // Replace this with your PUBLIC_API_KEY
    publicApiKey: "pk_ae8ecf5728684d22b5975cb2a966fdfe",
    // True if you want production mode on
    productionMode: false,
    // Mexico by default, also Colombia and Peru supported
    country: Country.MX,
  );
  @override
  void initState() {
    super.initState();
    initDeviceSession();
    initCardToken();
  }

  Future<void> initDeviceSession() async {
    String deviceID;
    try {
      deviceID =
          await openpay.getDeviceID() ?? 'Error getting the device session id';
    } catch (e) {
      rethrow;
    }

    setState(() {
      // THIS IS WHERE THE ID IS STORED
      _deviceID = deviceID;
    });
  }

  Future<void> initCardToken() async {
    String token;
    try {
      token = await openpay.getCardToken(
        CardInformation(
          holderName: 'Jose Perez Cruz',
          cardNumber: '5555555555554444',
          expirationYear: '25',
          expirationMonth: '8',
          cvv2: '213',
        ),
      );
    } catch (e) {
      rethrow;
    }

    setState(() {
      // THIS IS WHERE THE TOKEN IS STORED
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Openpay'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name : Jose Perez Cruz\n'),
            Text('Card Number : 5555555555554444\n'),
            Text('Expiration Year : 25\n'),
            Text('Expiration Month : 8\n'),
            Text('CVV2 : 213\n'),
            Text('Device ID : $_deviceID\n'), // THIS IS WHERE THE ID IS SHOWED
            Text(
                'Card Token: $_token\n'), // THIS IS WHERE THE CARD TOKEN IS SHOWED
          ],
        )),
      ),
    );
  }
}
