import 'package:flutter/material.dart';
import 'screens/inicio_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/incidencias_screen.dart';
import 'screens/detalle_screen.dart';
import 'screens/editar_screen.dart';

void main() {
  runApp(const SoporteApp());
}

class SoporteApp extends StatelessWidget {
  const SoporteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoporteApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/incidencias': (context) => const IncidenciasScreen(),
        '/detalle': (context) => const DetalleScreen(),
        '/editar': (context) => const EditarScreen(),
      },
    );
  }
}
