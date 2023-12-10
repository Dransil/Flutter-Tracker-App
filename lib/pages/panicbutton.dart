import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Boton extends StatelessWidget {
  const Boton({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _callNumber,
            child: Text('Llamar emergencias'),
          ),
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
