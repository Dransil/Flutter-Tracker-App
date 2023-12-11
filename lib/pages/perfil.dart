import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({Key? key}) : super(key: key);

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    // Aquí deberías cargar los datos del usuario, reemplázalo con tu lógica.
    _userData = {
      'nombre': 'Nombre del Usuario',
      'createdAt': DateTime.now(),
      // Agrega más datos según sea necesario
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Mi perfil')),
      ),
      backgroundColor: const Color.fromARGB(162, 7, 206, 159),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${_userData['nombre']}'),
            const SizedBox(height: 8),
            Text(
                'Creación de la cuenta: ${formatDate(_userData['createdAt'])}'),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
