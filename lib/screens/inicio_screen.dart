import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio - SoporteApp'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.support_agent,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gestión de Incidencias Técnicas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/registro'),
                icon: const Icon(Icons.add),
                label: const Text('Registrar Incidencia'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/incidencias'),
                icon: const Icon(Icons.list),
                label: const Text('Ver Incidencias'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
