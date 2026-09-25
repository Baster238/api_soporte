import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/incidencia.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/incidencias';

  static Future<List<Incidencia>> obtenerIncidencias() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Incidencia.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar las incidencias');
    }
  }

  static Future<bool> crearIncidencia(Incidencia incidencia) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incidencia.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> actualizarIncidencia(Incidencia incidencia) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${incidencia.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incidencia.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<bool> eliminarIncidencia(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 200;
  }
}
