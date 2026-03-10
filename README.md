# openpay_bbva

[![pub.dev](https://img.shields.io/pub/v/openpay_bbva.svg)](https://pub.dev/packages/openpay_bbva)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://pub.dev/packages/openpay_bbva)

A Flutter plugin for tokenizing card payments via the **Openpay BBVA** platform.

- **iOS / Android** — native Device Session ID via the official Openpay SDK (anti-fraud support).
- **All platforms** — card tokenization and card saving via HTTP (Web, Windows, macOS, Linux included).

---

[![Español](https://img.shields.io/badge/Language-Spanish-blueviolet?style=for-the-badge)](README_ES.md)

---

## Table of contents

- [Platform support](#platform-support)
- [Installation](#installation)
- [Android setup](#android-setup)
- [Usage](#usage)
  - [Initialize OpenpayBBVA](#1-initialize-openpaybbva)
  - [Get the Device Session ID](#2-get-the-device-session-id-ios--android)
  - [Tokenize a card](#3-tokenize-a-card)
  - [Save a card](#4-save-a-card)
  - [Error handling](#5-error-handling)
- [API reference](#api-reference)
- [Integrated libraries](#integrated-libraries)

---

## Platform support

| Feature                  | Android | iOS | Web | Windows | macOS | Linux |
|:-------------------------|:-------:|:---:|:---:|:-------:|:-----:|:-----:|
| Device Session ID        | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |
| Card tokenization (HTTP) | ✅      | ✅  | ✅  | ✅      | ✅    | ✅    |
| Save card (HTTP)         | ✅      | ✅  | ✅  | ✅      | ✅    | ✅    |

---

## Installation

Add `openpay_bbva` to your `pubspec.yaml`:

```yaml
dependencies:
  openpay_bbva: ^1.2.0
```

Then run:

```bash
flutter pub get
```

---

## Android setup

Add the following permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

## Usage

### 1. Initialize OpenpayBBVA

Obtain your **Merchant ID** and **Public API Key** from your [Openpay dashboard](https://www.openpay.mx).

> ⚠️ Always use your **public** API key. Never include your private key in client-side code.

```dart
import 'package:openpay_bbva/openpay_bbva.dart';

final openpay = OpenpayBBVA(
  merchantId: 'YOUR_MERCHANT_ID',
  publicApiKey: 'YOUR_PUBLIC_API_KEY',
  productionMode: false, // Set to true for production
  country: Country.MX,   // Country.MX | Country.CO | Country.PE
);
```

---

### 2. Get the Device Session ID *(iOS and Android only)*

The Device Session ID is required by Openpay's anti-fraud system. It identifies
the physical device that initiated the transaction and must be sent alongside the
card token when creating a server-side charge.

Returns `null` on Web, Windows, macOS, and Linux.

```dart
Future<void> fetchDeviceId() async {
  try {
    final deviceId = await openpay.getDeviceID();
    if (deviceId != null) {
      // Store deviceId and send it with your charge request
      print('Device Session ID: $deviceId');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

---

### 3. Tokenize a card

Tokenization converts sensitive card data into a one-time token that your
server can use to create charges. Works on all platforms.

```dart
Future<void> fetchCardToken() async {
  try {
    final token = await openpay.getCardToken(
      CardInformation(
        holderName: 'John Doe',
        cardNumber: '4111111111111111',
        expirationMonth: '12',
        expirationYear: '25',
        cvv2: '123',
      ),
    );
    // Send `token` to your backend to create a charge
    print('Card Token: $token');
  } on OpenpayExceptionError catch (e) {
    print('Openpay error ${e.error?.errorCode}: ${e.error?.description}');
  }
}
```

You can also include a billing address:

```dart
final card = CardInformation(
  holderName: 'John Doe',
  cardNumber: '4111111111111111',
  expirationMonth: '12',
  expirationYear: '25',
  cvv2: '123',
  address: Address(
    line1: '123 Main St',
    line2: 'Apt 4B',
    line3: 'Centro',
    city: 'Mexico City',
    state: 'CDMX',
    postalCode: '06600',
    countryCode: 'MX',
  ),
);
```

---

### 4. Save a card

Saves a card to your Openpay merchant account. The returned `CardInformation.id`
can be used for future charges without re-entering card data.

> **Note:** A $10.00 MXN authorization is made at save time and immediately reversed for validation.

```dart
Future<void> saveCard(String deviceSessionId) async {
  try {
    final saved = await openpay.saveCard(
      card: CardInformation(
        holderName: 'John Doe',
        cardNumber: '4111111111111111',
        expirationMonth: '12',
        expirationYear: '25',
        cvv2: '123',
      ),
      deviceSessionId: deviceSessionId,
    );
    print('Saved card ID: ${saved.id}');
  } on OpenpayExceptionError catch (e) {
    print('Openpay error ${e.error?.errorCode}: ${e.error?.description}');
  }
}
```

---

### 5. Error handling

All API errors are thrown as `OpenpayExceptionError`, which wraps a structured
`OpenpayError` object:

```dart
try {
  final token = await openpay.getCardToken(card);
} on OpenpayExceptionError catch (e) {
  final err = e.error;
  if (err != null) {
    print('HTTP ${err.httpCode}');        // e.g. 402
    print('Error code: ${err.errorCode}'); // e.g. 3001
    print('Category: ${err.category}');   // "gateway"
    print('Description: ${err.description}');
  }
}
```

Common error codes:

| Code | Meaning                              |
|-----:|:-------------------------------------|
| 1001 | Invalid request format               |
| 1002 | Authentication failure               |
| 2004 | Invalid card number (Luhn check)     |
| 2005 | Card is expired                      |
| 3001 | Card declined                        |
| 3002 | Card expired                         |
| 3003 | Insufficient funds                   |

See [OpenpayError](lib/src/models/openpay_error.dart) for the full list.

---

## API reference

| Class / Member                              | Description                                          |
|:--------------------------------------------|:-----------------------------------------------------|
| `OpenpayBBVA`                               | Main plugin class                                    |
| `OpenpayBBVA.getDeviceID()`                 | Returns Device Session ID (iOS/Android) or `null`    |
| `OpenpayBBVA.getCardToken(CardInformation)` | Tokenizes a card, returns the token `String`         |
| `OpenpayApi.getToken(CardInformation)`      | Tokenizes a card, returns `TokenOpenpay`             |
| `OpenpayApi.saveCard({card, deviceSessionId})` | Saves a card, returns stored `CardInformation`    |
| `CardInformation`                           | Card data model (input & response)                   |
| `TokenOpenpay`                              | Token response model                                 |
| `Address`                                   | Billing address model                                |
| `OpenpayExceptionError`                     | Exception thrown on API errors                       |
| `OpenpayError`                              | Structured Openpay error payload                     |
| `Country`                                   | Enum: `Country.MX`, `Country.CO`, `Country.PE`      |

---

## Integrated libraries

- [Openpay iOS SDK](https://github.com/open-pay/openpay-swift-ios)
- [Openpay Android SDK](https://github.com/open-pay/openpay-android)
- [Openpay REST API](https://documents.openpay.mx/docs/api/)
- [Anti-Fraud System](https://documents.openpay.mx/docs/fraud-tool.html)
