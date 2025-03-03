import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Para mostrar notificaciones localmente

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Configura las notificaciones locales
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Solicita permisos (solo en iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Obtén el token FCM
      String? token = await _firebaseMessaging.getToken();
      print("Token FCM: $token");

      // Escucha mensajes en primer plano
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Mensaje en primer plano: ${message.data}');
        _showNotification(message);
      });

      // Maneja mensajes en segundo plano
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
  }

  // Muestra una notificación local
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // ID del canal
      'your_channel_name', // Nombre del canal
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      message.notification?.title, // Título de la notificación
      message.notification?.body, // Cuerpo de la notificación
      platformChannelSpecifics,
    );
  }

  // Maneja mensajes en segundo plano
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Mensaje en segundo plano: ${message.messageId}");
  }
}