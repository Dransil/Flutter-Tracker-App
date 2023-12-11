import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto/auth.dart';
import 'package:flutter/material.dart';
// Suitable for most situations
// Only import if required functionality is not exposed by default
import 'package:proyecto/pages/crud.dart';
import 'package:proyecto/pages/maplivelocation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:proyecto/pages/todo.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('SafeTrack');
  }

  Widget _userUid() {
    return Text(
      'Bienvenid@ ${user?.displayName ?? 'User email'} ${user?.email ?? 'User email'} ${user?.uid ?? 'User email'}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: Color.fromARGB(255, 0, 0, 0),
        letterSpacing: 1,
      ),
    );
  }

  Widget _signOutButton() {
    return InkWell(
      onTap: () {
        signOut();
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
              Icons.logout,
              size: 24,
              color: Colors.green,
            ),
            Text(
              "  Salir de la cuenta",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goToMap(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LiveLocationPage1()));
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
              Icons.map_outlined,
              size: 24,
              color: Colors.green,
            ),
            Text(
              "  Mapa con dispositivo",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goToCrud(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ShowCrud()));
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
              Icons.supervised_user_circle_sharp,
              size: 24,
              color: Colors.green,
            ),
            Text(
              "  Registro de personas",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goToLiveLocation(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LiveLocationPage()));
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
              Icons.location_on_sharp,
              size: 24,
              color: Colors.green,
            ),
            Text(
              "  Ubicación actual",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goToTodo(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LiveLocationPage1()));
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
              Icons.location_on_sharp,
              size: 24,
              color: Colors.green,
            ),
            Text(
              "  Ubicación actual",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goToDanger(BuildContext context) {
    return InkWell(
      onTap: () {
        _callNumber();
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
              Icons.map_outlined,
              size: 24,
              color: Colors.green,
            ),
            Text(
              "  Llamada de emergencia",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100.0,
              backgroundImage: NetworkImage('${user?.photoURL}'),
            ),
            _userUid(),
            const SizedBox(height: 20),
            _goToMap(context),
            const SizedBox(height: 6),
            _goToCrud(context),
            const SizedBox(height: 6),
            _goToLiveLocation(context),
            const SizedBox(height: 6),
            _goToDanger(context),
            const SizedBox(height: 6),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}

_callNumber() async {
  const number = '59163980440';
  //se pone el 911 pero no mas no llamaremos porque parecera broma
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
}
