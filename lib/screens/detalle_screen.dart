import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/api_service.dart';

class DetalleScreen extends StatefulWidget {
  const DetalleScreen({super.key});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  IconData _obtenerIconoPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Baja':
        return Icons.info;
      case 'Media':
        return Icons.warning;
      case 'Alta':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Color _obtenerColorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Baja':
        return Colors.blue;
      case 'Media':
        return Colors.orange;
      case 'Alta':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _confirmarEliminacion(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Está seguro de que desea eliminar esta incidencia?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final exito = await ApiService.eliminarIncidencia(id);
                if (exito && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incidencia eliminada correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al eliminar la incidencia'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidencia = ModalRoute.of(context)!.settings.arguments as Incidencia;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Incidencia'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _obtenerIconoPrioridad(incidencia.prioridad),
                          size: 40,
                          color: _obtenerColorPrioridad(incidencia.prioridad),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            incidencia.nombreUsuario,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Correo electrónico'),
                      subtitle: Text(incidencia.correo),
                    ),
                    ListTile(
                      leading: const Icon(Icons.computer),
                      title: const Text('Número de equipo'),
                      subtitle: Text('#${incidencia.numeroEquipo}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Descripción del problema'),
                      subtitle: Text(incidencia.descripcion),
                    ),
                    ListTile(
                      leading: const Icon(Icons.flag),
                      title: const Text('Prioridad'),
                      subtitle: Text(incidencia.prioridad),
                    ),
                    ListTile(
                      leading: const Icon(Icons.sync),
                      title: const Text('Estado'),
                      subtitle: Text(incidencia.estado),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Fecha de registro'),
                      subtitle: Text(incidencia.fechaRegistro ?? 'N/A'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        '/editar',
                        arguments: incidencia,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (incidencia.id != null) {
                        _confirmarEliminacion(context, incidencia.id!);
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
