# openpay_bbva

[![pub.dev](https://img.shields.io/pub/v/openpay_bbva.svg)](https://pub.dev/packages/openpay_bbva)
[![Licencia: MIT](https://img.shields.io/badge/Licencia-MIT-blue.svg)](LICENSE)
[![Plataforma](https://img.shields.io/badge/plataforma-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://pub.dev/packages/openpay_bbva)

Plugin de Flutter para tokenizar pagos con tarjeta a través de la plataforma **Openpay BBVA**.

- **iOS / Android** — ID de sesión de dispositivo nativo mediante el SDK oficial de Openpay (soporte antifraude).
- **Todas las plataformas** — Tokenización de tarjetas y guardado de tarjetas vía HTTP (Web, Windows, macOS y Linux incluidos).

---

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

---

## Tabla de contenidos

- [Soporte de plataformas](#soporte-de-plataformas)
- [Instalación](#instalación)
- [Configuración Android](#configuración-android)
- [Uso](#uso)
  - [Inicializar OpenpayBBVA](#1-inicializar-openpaybbva)
  - [Obtener el ID de sesión de dispositivo](#2-obtener-el-id-de-sesión-de-dispositivo-ios-y-android)
  - [Tokenizar una tarjeta](#3-tokenizar-una-tarjeta)
  - [Guardar una tarjeta](#4-guardar-una-tarjeta)
  - [Manejo de errores](#5-manejo-de-errores)
- [Referencia de API](#referencia-de-api)
- [Librerías integradas](#librerías-integradas)

---

## Soporte de plataformas

| Función                       | Android | iOS | Web | Windows | macOS | Linux |
|:------------------------------|:-------:|:---:|:---:|:-------:|:-----:|:-----:|
| ID de sesión de dispositivo   | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |
| Tokenización de tarjeta (HTTP)| ✅      | ✅  | ✅  | ✅      | ✅    | ✅    |
| Guardar tarjeta (HTTP)        | ✅      | ✅  | ✅  | ✅      | ✅    | ✅    |

---

## Instalación

Agrega `openpay_bbva` a tu `pubspec.yaml`:

```yaml
dependencies:
  openpay_bbva: ^1.2.0
```

Luego ejecuta:

```bash
flutter pub get
```

---

## Configuración Android

Agrega los siguientes permisos a tu `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

## Uso

### 1. Inicializar OpenpayBBVA

Obtén tu **Merchant ID** y **Public API Key** desde tu [panel de Openpay](https://www.openpay.mx).

> ⚠️ Utiliza siempre tu clave **pública**. Nunca incluyas tu clave privada en el código del cliente.

```dart
import 'package:openpay_bbva/openpay_bbva.dart';

final openpay = OpenpayBBVA(
  merchantId: 'TU_MERCHANT_ID',
  publicApiKey: 'TU_PUBLIC_API_KEY',
  productionMode: false, // Cambia a true para producción
  country: Country.MX,   // Country.MX | Country.CO | Country.PE
);
```

---

### 2. Obtener el ID de sesión de dispositivo *(solo iOS y Android)*

El ID de sesión de dispositivo es requerido por el sistema antifraude de Openpay.
Identifica el dispositivo físico que inicia la transacción y debe enviarse junto
con el token de tarjeta al crear un cargo en el servidor.

Devuelve `null` en Web, Windows, macOS y Linux.

```dart
Future<void> obtenerDeviceId() async {
  try {
    final deviceId = await openpay.getDeviceID();
    if (deviceId != null) {
      // Guarda el deviceId y envíalo junto con tu solicitud de cargo
      print('ID de sesión: $deviceId');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

---

### 3. Tokenizar una tarjeta

La tokenización convierte los datos sensibles de la tarjeta en un token de un
solo uso que tu servidor puede usar para crear cargos. Funciona en todas las plataformas.

```dart
Future<void> tokenizarTarjeta() async {
  try {
    final token = await openpay.getCardToken(
      CardInformation(
        holderName: 'Juan Pérez Cruz',
        cardNumber: '4111111111111111',
        expirationMonth: '12',
        expirationYear: '25',
        cvv2: '123',
      ),
    );
    // Envía `token` a tu backend para crear un cargo
    print('Token de tarjeta: $token');
  } on OpenpayExceptionError catch (e) {
    print('Error Openpay ${e.error?.errorCode}: ${e.error?.description}');
  }
}
```

También puedes incluir una dirección de facturación:

```dart
final card = CardInformation(
  holderName: 'Juan Pérez Cruz',
  cardNumber: '4111111111111111',
  expirationMonth: '12',
  expirationYear: '25',
  cvv2: '123',
  address: Address(
    line1: 'Av. Insurgentes Sur 123',
    line2: 'Piso 4',
    line3: 'Col. Centro',
    city: 'Ciudad de México',
    state: 'CDMX',
    postalCode: '06600',
    countryCode: 'MX',
  ),
);
```

---

### 4. Guardar una tarjeta

Guarda una tarjeta en tu cuenta de comercio de Openpay. El `CardInformation.id`
devuelto puede usarse para cargos futuros sin volver a ingresar los datos de la tarjeta.

> **Nota:** Al guardar, se realiza una autorización de $10.00 MXN que se revierte de inmediato, como validación.

```dart
Future<void> guardarTarjeta(String deviceSessionId) async {
  try {
    final saved = await openpay.saveCard(
      card: CardInformation(
        holderName: 'Juan Pérez Cruz',
        cardNumber: '4111111111111111',
        expirationMonth: '12',
        expirationYear: '25',
        cvv2: '123',
      ),
      deviceSessionId: deviceSessionId,
    );
    print('ID de tarjeta guardada: ${saved.id}');
  } on OpenpayExceptionError catch (e) {
    print('Error Openpay ${e.error?.errorCode}: ${e.error?.description}');
  }
}
```

---

### 5. Manejo de errores

Todos los errores de la API se lanzan como `OpenpayExceptionError`, que envuelve
un objeto estructurado `OpenpayError`:

```dart
try {
  final token = await openpay.getCardToken(card);
} on OpenpayExceptionError catch (e) {
  final err = e.error;
  if (err != null) {
    print('HTTP ${err.httpCode}');          // ej. 402
    print('Código de error: ${err.errorCode}'); // ej. 3001
    print('Categoría: ${err.category}');   // "gateway"
    print('Descripción: ${err.description}');
  }
}
```

Códigos de error más comunes:

| Código | Significado                              |
|-------:|:-----------------------------------------|
| 1001   | Formato de solicitud inválido            |
| 1002   | Fallo de autenticación                   |
| 2004   | Número de tarjeta inválido (Luhn)        |
| 2005   | Tarjeta vencida                          |
| 3001   | Tarjeta declinada                        |
| 3002   | Tarjeta expirada                         |
| 3003   | Fondos insuficientes                     |

Consulta [OpenpayError](lib/src/models/openpay_error.dart) para la lista completa.

---

## Referencia de API

| Clase / Miembro                               | Descripción                                                 |
|:----------------------------------------------|:------------------------------------------------------------|
| `OpenpayBBVA`                                 | Clase principal del plugin                                  |
| `OpenpayBBVA.getDeviceID()`                   | Devuelve el ID de sesión de dispositivo (iOS/Android) o `null` |
| `OpenpayBBVA.getCardToken(CardInformation)`   | Tokeniza una tarjeta, devuelve el `String` del token        |
| `OpenpayApi.getToken(CardInformation)`        | Tokeniza una tarjeta, devuelve `TokenOpenpay`               |
| `OpenpayApi.saveCard({card, deviceSessionId})`| Guarda una tarjeta, devuelve `CardInformation` almacenada   |
| `CardInformation`                             | Modelo de datos de tarjeta (entrada y respuesta)            |
| `TokenOpenpay`                                | Modelo de respuesta de token                                |
| `Address`                                     | Modelo de dirección de facturación                          |
| `OpenpayExceptionError`                       | Excepción lanzada en errores de API                         |
| `OpenpayError`                                | Payload de error estructurado de Openpay                    |
| `Country`                                     | Enum: `Country.MX`, `Country.CO`, `Country.PE`             |

---

## Librerías integradas

- [Openpay iOS SDK](https://github.com/open-pay/openpay-swift-ios)
- [Openpay Android SDK](https://github.com/open-pay/openpay-android)
- [API REST de Openpay](https://documents.openpay.mx/docs/api/)
- [Sistema Antifraude](https://documents.openpay.mx/docs/fraud-tool.html)
