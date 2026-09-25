import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/api_service.dart';

class IncidenciasScreen extends StatefulWidget {
  const IncidenciasScreen({super.key});

  @override
  State<IncidenciasScreen> createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {
  late Future<List<Incidencia>> _futureIncidencias;

  @override
  void initState() {
    super.initState();
    _cargarIncidencias();
  }

  void _cargarIncidencias() {
    setState(() {
      _futureIncidencias = ApiService.obtenerIncidencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Incidencias'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Incidencia>>(
        future: _futureIncidencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al obtener los datos:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay incidencias registradas.'));
          }

          final lista = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _cargarIncidencias();
            },
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final item = lista[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      item.nombreUsuario,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Equipo: #${item.numeroEquipo} | Estado: ${item.estado}',
                    ),
                    trailing: Chip(
                      label: Text(
                        item.prioridad,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: item.prioridad == 'Alta'
                          ? Colors.red
                          : item.prioridad == 'Media'
                          ? Colors.orange
                          : Colors.blue,
                    ),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/detalle',
                        arguments: item,
                      );
                      _cargarIncidencias();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
