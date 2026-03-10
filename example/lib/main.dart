// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:openpay_bbva/openpay_bbva.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the Openpay BBVA example application.
///
/// Demonstrates the two core features of the package:
/// 1. Retrieving a **Device Session ID** (iOS and Android only).
/// 2. Tokenizing a **credit/debit card** on any platform.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ──────────────────────────────────────────────────────────────────────────
  // Openpay instance
  //
  // Replace the values below with your own credentials from the Openpay
  // dashboard (https://www.openpay.mx).
  //
  // ⚠️  Never use your PRIVATE API key here — always use the PUBLIC key.
  // ──────────────────────────────────────────────────────────────────────────
  final _openpay = OpenpayBBVA(
    merchantId: 'mliwbrm4orj40lhks7kv',   // TODO: replace with your merchant ID
    publicApiKey: 'pk_ae8ecf5728684d22b5975cb2a966fdfe', // TODO: replace with your public API key
    productionMode: false, // Set to true for production
    country: Country.MX,   // Change to Country.CO or Country.PE as needed
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Sample card data used for the tokenization demo
  //
  // These are Openpay sandbox test card values. Do NOT use real card numbers
  // in sandbox mode.
  // ──────────────────────────────────────────────────────────────────────────
  final _card = CardInformation(
    holderName: 'Jose Perez Cruz',
    cardNumber: '5555555555554444',
    expirationMonth: '08',
    expirationYear: '25',
    cvv2: '213',
  );

  String _deviceId = 'Retrieving…';
  String _token = 'Retrieving…';
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDeviceId();
    _fetchCardToken();
  }

  // Retrieves the Device Session ID via the native Openpay SDK.
  // Returns null on non-mobile platforms.
  Future<void> _fetchDeviceId() async {
    try {
      final id = await _openpay.getDeviceID();
      setState(() {
        _deviceId = id ?? 'Not available on this platform';
      });
    } catch (e) {
      setState(() {
        _deviceId = 'Error';
        _error = e.toString();
      });
      print('getDeviceID error: $e');
    }
  }

  // Tokenizes the sample card via the Openpay HTTP API.
  Future<void> _fetchCardToken() async {
    try {
      final token = await _openpay.getCardToken(_card);
      setState(() {
        _token = token;
      });
    } on OpenpayExceptionError catch (e) {
      // Structured Openpay error — inspect e.error for details
      setState(() {
        _token = 'Error';
        _error = e.toString();
      });
      print('getCardToken Openpay error: $e');
    } catch (e) {
      setState(() {
        _token = 'Error';
        _error = e.toString();
      });
      print('getCardToken unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Openpay BBVA Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Openpay BBVA Example'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Card details ──────────────────────────────────────────────
              _SectionTitle('Card details'),
              _InfoRow('Holder name', _card.holderName),
              _InfoRow('Card number', _card.cardNumber),
              _InfoRow('Expiration', '${_card.expirationMonth}/${_card.expirationYear}'),
              _InfoRow('CVV2', _card.cvv2),
              const SizedBox(height: 24),

              // ── Results ───────────────────────────────────────────────────
              _SectionTitle('Results'),
              _InfoRow('Device Session ID', _deviceId),
              _InfoRow('Card Token', _token),

              // ── Error (if any) ────────────────────────────────────────────
              if (_error != null) ...[
                const SizedBox(height: 24),
                _SectionTitle('Error'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple section title widget.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Displays a labeled key-value pair.
class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }
}
