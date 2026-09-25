import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/api_service.dart';

class EditarScreen extends StatefulWidget {
  const EditarScreen({super.key});

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usuarioController;
  late TextEditingController _correoController;
  late TextEditingController _equipoController;
  late TextEditingController _descripcionController;

  String? _prioridadSeleccionada;
  String? _estadoSeleccionado;

  bool _cargando = false;
  bool _inicializado = false;
  late Incidencia _incidenciaActual;

  final List<String> _prioridades = ['Baja', 'Media', 'Alta'];
  final List<String> _estados = ['Pendiente', 'En proceso', 'Resuelta'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      _incidenciaActual =
          ModalRoute.of(context)!.settings.arguments as Incidencia;

      _usuarioController = TextEditingController(
        text: _incidenciaActual.nombreUsuario,
      );
      _correoController = TextEditingController(text: _incidenciaActual.correo);
      _equipoController = TextEditingController(
        text: _incidenciaActual.numeroEquipo.toString(),
      );
      _descripcionController = TextEditingController(
        text: _incidenciaActual.descripcion,
      );

      _prioridadSeleccionada = _incidenciaActual.prioridad;
      _estadoSeleccionado = _incidenciaActual.estado;

      _inicializado = true;
    }
  }

  Future<void> _actualizarIncidencia() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cargando = true;
      });

      final incidenciaEditada = Incidencia(
        id: _incidenciaActual.id,
        nombreUsuario: _usuarioController.text,
        correo: _correoController.text,
        numeroEquipo: int.parse(_equipoController.text),
        descripcion: _descripcionController.text,
        prioridad: _prioridadSeleccionada!,
        estado: _estadoSeleccionado!,
        fechaRegistro: _incidenciaActual.fechaRegistro,
      );

      try {
        final exito = await ApiService.actualizarIncidencia(incidenciaEditada);
        setState(() {
          _cargando = false;
        });

        if (exito && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incidencia actualizada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al actualizar la incidencia'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _cargando = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error de conexión: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Incidencia'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usuarioController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del usuario',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        if (value.trim().length < 3) {
                          return 'Debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Ingrese un correo válido (debe contener @ y .)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _equipoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número de equipo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        final numero = int.tryParse(value);
                        if (numero == null) {
                          return 'Debe ser un valor numérico';
                        }
                        if (numero <= 0) {
                          return 'El número debe ser mayor que 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descripcionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción del problema',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        if (value.trim().length < 10) {
                          return 'Debe tener al menos 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _prioridadSeleccionada,
                      decoration: const InputDecoration(
                        labelText: 'Prioridad',
                        border: OutlineInputBorder(),
                      ),
                      items: _prioridades.map((String prioridad) {
                        return DropdownMenuItem<String>(
                          value: prioridad,
                          child: Text(prioridad),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _prioridadSeleccionada = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleccione una prioridad';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _estadoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(),
                      ),
                      items: _estados.map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _estadoSeleccionado = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleccione un estado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _actualizarIncidencia,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
