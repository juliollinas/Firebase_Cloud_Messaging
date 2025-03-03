import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart'; // Importa los proveedores
import '../../../../services/fcm_service.dart'; // Importa el servicio de FCM

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtén el estado de la inicialización de Firebase
    final firebaseInitialization = ref.watch(firebaseProvider);

    // Inicializa FCM cuando la pantalla se construye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fcmServiceProvider).initialize();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: firebaseInitialization.when(
          loading: () => CircularProgressIndicator(), // Muestra un indicador de carga
          error: (error, stack) => Text('Error: $error'), // Muestra un mensaje de error
          data: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a la aplicación!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Icon(
                Icons.home,
                size: 50,
                color: Colors.orange,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Acción del botón
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Botón presionado!')),
                  );
                },
                child: Text('Presiona aquí'),
              ),
            ],
          ), // Muestra la interfaz principal
        ),
      ),
    );
  }
}