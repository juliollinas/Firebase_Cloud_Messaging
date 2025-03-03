# Estructura de Carpetas

``` html

lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── providers/
│   │   └── app_providers.dart
├── features/
│   └── home/
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── home_screen.dart
│       │   └── widgets/
│       │       └── home_widget.dart
│       └── application/
│           └── home_service.dart
├── services/
│   └── fcm_service.dart
├── utils/
│   └── constants.dart

```


Explicación de cada archivo y carpeta

## 1. lib/main.dart

Responsabilidad: Punto de entrada de la aplicación.

Contenido:

Inicializa Firebase.

Configura el ProviderScope (de Riverpod) para manejar el estado global.

Inicia la aplicación llamando a App().

Código de ejemplo:

``` dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: App()));
}

```

## 2. lib/app/app.dart
Responsabilidad: Define la estructura principal de la aplicación (tema, rutas, etc.).

Contenido:

Configura el MaterialApp con un tema y rutas.

Código de ejemplo:

``` dart

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

```

## 3. lib/app/providers/app_providers.dart
Responsabilidad: Define los proveedores globales de Riverpod.

Contenido:

Proveedores para servicios globales como FcmService.

Código de ejemplo:

``` dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/fcm_service.dart';

final fcmServiceProvider = Provider<FcmService>((ref) => FcmService());

```


## 4. lib/features/home/presentation/screens/home_screen.dart
Responsabilidad: Pantalla principal de la aplicación.

Contenido:

Muestra la interfaz de usuario y maneja la lógica de la pantalla.

Puede escuchar proveedores de Riverpod para actualizar el estado.

Código de ejemplo:

``` dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/home_service.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fcmService = ref.read(fcmServiceProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fcmService.initialize();
    });

    return Scaffold(
      appBar: AppBar(title: Text('FCM Demo')),
      body: Center(child: Text('Firebase Cloud Messaging Demo')),
    );
  }
}

```

## 5. lib/features/home/application/home_service.dart
Responsabilidad: Lógica de negocio relacionada con la pantalla principal.

Contenido:

Métodos y funciones que interactúan con servicios externos (por ejemplo, FCM).

Código de ejemplo:

``` dart

class HomeService {
  // Aquí puedemoss agregar métodos específicos para la pantalla principal.
}

```

6. lib/services/fcm_service.dart
Responsabilidad: Maneja la lógica de Firebase Cloud Messaging.

Contenido:

Inicializa FCM.

Escucha mensajes en primer y segundo plano.

Obtiene y maneja el token FCM.

Código de ejemplo:

``` dart

import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Solicita permisos (solo en iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Obtén el token FCM
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      // Escucha mensajes en primer plano
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Mensaje en primer plano: ${message.data}');
      });

      // Maneja mensajes en segundo plano
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Mensaje en segundo plano: ${message.messageId}");
  }
}

```

## Resumen de la estructura

main.dart: Punto de entrada.

app/: Configuración global de la aplicación (tema, proveedores, etc.).

features/: Divide la aplicación en características (por ejemplo, home). Cada característica tiene su propia lógica y presentación.

services/: Contiene servicios globales como FcmService.

utils/: Utilidades y constantes globales.


### Beneficios de esta estructura

Separación de responsabilidades: Cada archivo y carpeta tiene una responsabilidad clara.

Escalabilidad: Facilita la adición de nuevas características.

Mantenibilidad: El código está organizado y es fácil de entender.

Reutilización: Los servicios y utilidades pueden ser reutilizados en toda la aplicación.