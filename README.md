# Openpay BBVA

## Languages

[![Español](https://img.shields.io/badge/Language-Spanish-blueviolet?style=for-the-badge)](README_ES.md)

## Libraries integrates

-[Openpay iOS](https://github.com/open-pay/openpay-swift-ios "Openpay iOS")

-[Openpay Android](https://github.com/open-pay/openpay-android "Openpay Android")

-[Openpay API](https://documents.openpay.mx/docs/api/#api-endpoints "Openpay API") to generate the Device Session ID used in the Openpay

-[Anti-Fraud System](https://documents.openpay.mx/docs/fraud-tool.html "Anti-Fraud System")

- [Card Token](https://documents.openpay.mx/docs/api/#crear-una-tarjeta-con-token "Card Token") for the card payments through their app

-[API.](https://documents.openpay.mx/docs/api/ "API.")

## Usage

### Initialize OpenpayBBVA instance

```dart
        // Example MERCHANT_ID and PUBLIC_API_KEY
            final openpay = OpenpayBBVA(
            "m2tmftuv5jao96rrezj2", // Replace this with your MERCHANT_ID
            "pk_d5e9bff37db4468da3f80148bb94f263", // Replace this with your PUBLIC_API_KEY
            productionMode: false, // True if you want production mode on
            Country: Country.MX); // Mexico by default, also Colombia & Peru supported

```

### Get your Device Session ID *(iOS and Android only)*

```dart

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

```

### Get your Card Token

```dart

        Future<void> initCardToken() async {
            String token;
            try {
                token = await openpay.getCardToken(
                    CardInformation(
                    holderName: 'Jose Perez Cruz',
                    cardNumber: '5555555555554444',
                    expirationYear: '23',
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

```

With this information, you can process card payments through Openpay.
