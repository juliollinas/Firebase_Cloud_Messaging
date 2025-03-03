import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../services/fcm_service.dart';

// Proveedor para inicializar Firebase
final firebaseProvider = FutureProvider<void>((ref) async {
  await Firebase.initializeApp();
});

// Proveedor para el servicio de FCM
final fcmServiceProvider = Provider<FcmService>((ref) => FcmService());