import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({Key? key}) : super(key: key);

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final User? user = Auth().currentUser;
  final CollectionReference _datos =
      FirebaseFirestore.instance.collection('users');

  DateTime? _createdAt;
  String? _telefono;

  TextEditingController _telefonoController = TextEditingController();

  bool _editingTelefono = false;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _datos.doc(user?.uid).get();
      if (userData.exists) {
        setState(() {
          _createdAt = (userData['createdAt'] as Timestamp).toDate();
          _telefono = userData['telefono'];
          _telefonoController.text = _telefono ?? '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _updateTelefono() async {
    // Actualizar el número de teléfono en la base de datos
    try {
      await _datos
          .doc(user?.uid)
          .update({'telefono': _telefonoController.text});
      // Recargar los datos del usuario después de la actualización
      await _loadUserData();
      // Salir del modo de edición
      setState(() {
        _editingTelefono = false;
      });
    } catch (e) {
      print('Error updating telefono: $e');
    }
  }

  @override
  Widget _userUid() {
    return Center(
      child: Text(
        'Bienvenid@ ${user?.displayName ?? 'User email'}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _telefonoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Teléfono:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _telefonoController,
          keyboardType: TextInputType.phone,
          enabled: _editingTelefono,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white, // Establecer el color de fondo
            hintText: 'Número de teléfono',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(
              fontSize: 18, color: Colors.black), // Ajustar el color del texto
        ),
        const SizedBox(height: 10),
        if (_editingTelefono)
          ElevatedButton(
            onPressed: () => _updateTelefono(),
            child: Text('Guardar teléfono', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
      ],
    );
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
            _userUid(),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 100.0,
                backgroundImage: NetworkImage('${user?.photoURL}'),
              ),
            ),
            const SizedBox(height: 20),
            if (_createdAt != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.green, // Color del borde
                      width: 2.0, // Ancho del borde
                    ),
                  ),
                  child: Text(
                    'Creación de la cuenta: ${formatDate(_createdAt!)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 0, 0, 0),
                      letterSpacing: 1,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _telefonoWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _editingTelefono = !_editingTelefono;
          });
        },
        child: Icon(_editingTelefono ? Icons.done : Icons.edit),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
