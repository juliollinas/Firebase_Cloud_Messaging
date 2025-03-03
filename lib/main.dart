import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase inicializado correctamente");
  } catch (e) {
    print("Error al inicializar Firebase: $e");
  }
  runApp(
    ProviderScope( // Envuelve la aplicación en un ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Básica',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Usa HomeScreen como pantalla inicial
    );
  }
}