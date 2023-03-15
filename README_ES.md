# Openpay BBVA

## Get Started

### Android

Agrega estos permisos a tu Android Manifest

```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## Idiomas

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

## Librerías Integradas

-[Openpay iOS](https://github.com/open-pay/openpay-swift-ios "Openpay iOS")

-[Openpay Android](https://github.com/open-pay/openpay-android "Openpay Android")

-[Openpay API](https://documents.openpay.mx/docs/api/#api-endpoints "Openpay API") para generar el ID de sesión del dispositivo utilizado en Openpay

-[Anti-Fraud System](https://documents.openpay.mx/docs/fraud-tool.html "Sistema Antifraude")

-[Card Token](https://documents.openpay.mx/docs/api/#crear-una-tarjeta-con-token "Card Token") para pagos con tarjeta a traves de la aplicación

-[API.](https://documents.openpay.mx/docs/api/ "API.")

## Uso

### Inicializar la Instancia OpenpayBBVA

```dart
            // Example MERCHANT_ID and PUBLIC_API_KEY
            final openpay = OpenpayBBVA(
           merchantId: "m2tmftuv5jao96rrezj2", // Reemplaza con tu MERCHANT_ID
           publicApiKey: "pk_d5e9bff37db4468da3f80148bb94f263", // Reemplaza con tu PUBLIC_API_KEY
            productionMode: false, // Si es verdadero, se usa el modo producción 
            Country: Country.MX); // Por defecto se usa México, pero también Colombia & Peru son soportados

```

### Obten el ID de sesión de Dispositivo *(solo iOS y Android)*

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
            // Ejemplo de como guardar en memoria el dispositivo
            _deviceID = deviceID;
            });
        }
```

### Consigue tu *Card Token*  

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
            // Ejemplo de como guardar en memoria el token
            _token = token;
            });
        }
```

Con esta información, puede procesar pagos con tarjeta a través de Openpay.
