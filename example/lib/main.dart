import 'package:flutter/material.dart';
import 'package:openpay_bbva/openpay_api.dart';
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
  OpenpayBBVA openpay = OpenpayBBVA(
      "m2tmftuv5jao96rrezj2", // Replace this with your MERCHANT_ID
      "pk_d5e9bff37db4468da3f80148bb94f263", // Replace this with your PUBLIC_API_KEY
      productionMode: false, // True if you want production mode on
      country: Country
          .Mexico); // Mexico by default, also Colombia and Peru supported
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
              'Jose Perez Cruz', '411111111111111', '8', '23', '213') ??
          'Error getting the card token';
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
            Text('Device ID : $_deviceID\n'), // THIS IS WHERE THE ID IS SHOWED
            Text(
                'Card Token: $_token\n'), // THIS IS WHERE THE CARD TOKEN IS SHOWED
          ],
        )),
      ),
    );
  }
}
