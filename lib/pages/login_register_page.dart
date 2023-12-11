import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto/auth_folder.dart';
import 'package:proyecto/iconos/redes_icons_icons.dart';
import '../auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  Widget _title() {
    return const Text('SafeTrack');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FD),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475269).withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person,
            size: 27,
            color: Color(0xFF475369),
          ),
          const SizedBox(width: 10),
          SizedBox(
            //margin: EdgeInsets,
            width: 200,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorMessage() {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          errorMessage == '' ? '' : '$errorMessage',
          style: const TextStyle(color: Colors.red),
        ));
  }

  Widget _icon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SafeTrack',
          style: GoogleFonts.antonio(fontSize: 48, color: Colors.white),
        ),
        const Icon(
          Icons.beenhere_outlined,
          size: 100,
          color: Colors.white,
        )
      ],
    );
  }

  Widget _forgotpassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ForgotPasswordPage();
                  },
                ),
              );
            },
            child: const Text(
              '¿Olvidaste la contraseña?',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<User?> signInWithGooglefunc() async {
    // Tu código actual para iniciar sesión con Google
    await AuthService().signInWithGoogle();

    // Obtener el usuario actual después de la autenticación con Google
    final User? user = Auth().currentUser;

    // Llamada al método de registro automático después de iniciar sesión con Google
    if (user != null) {
      await _registerUserIfNotExists(user);
    }

    return user;
  }

  Future<void> _registerUserIfNotExists(User? user) async {
    // Verificar si el usuario ya existe en la base de datos
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (!userDoc.exists) {
      // Si el usuario no existe, crea un nuevo documento en la colección 'users'
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        centerTitle: true,
        leading: const Icon(
          Icons.beenhere_outlined,
          size: 25,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(162, 7, 206, 159),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _icon(),
              _errorMessage(),
              _forgotpassword(),
              InkWell(
                onTap: () {
                  signInWithGooglefunc();
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(221, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xDD475269).withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        RedesIcons.google,
                        size: 20,
                        color: Colors.green,
                      ),
                    ],
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
