import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Reconai extends StatefulWidget {
  const Reconai({super.key});

  @override
  State<Reconai> createState() => _ReconaiState();
}

class _ReconaiState extends State<Reconai> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _conjuntoLetras = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _conjuntoLetras = "${result.recognizedWords}";

      if (_conjuntoLetras.toLowerCase().contains('fuego')) {
        _showAlert(
            'Manten la calma y busca una alarma de incendios, llama a emergencias inmediatamente, busca un extintor y evacua el área inmediatamente, intenta evitar el humo y sal del lugar');
      } else if (_conjuntoLetras.toLowerCase().contains('terremoto')) {
        _showAlert(
            'Manten la calma y alejate de estantes, vitrinas o alguna repisa que pueda hacer que te caigan objetos, si estás en casa ponte debajo de un mueble, si estás fuera alejate de los edificios');
      } else if (_conjuntoLetras.toLowerCase().contains('inundación')) {
        _showAlert(
            'Intenta desconectar o cortar la electricidad y busca terreno alto, si es un edificio sube al último piso y espera ayuda de las autoridades');
      } else if (_conjuntoLetras.toLowerCase().contains('secuestro')) {
        _showAlert(
            'Estamos proporcionando tu ubicación a las autoridades, mantén la calma y colabora con los secuestradores');
      }
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta!!!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Lo tengo entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('Reconocimiento'),
      )),
      backgroundColor: const Color.fromARGB(162, 7, 206, 159),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Escuchando..."
                    : _speechEnabled
                        ? "Presiona el micrófono para hablar..."
                        : "Reconocimiento no disponible",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _conjuntoLetras,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        label: Text(
          _speechToText.isNotListening ? 'Iniciar' : 'Detener',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        icon: Icon(
          size: 54,
          _speechToText.isNotListening ? Icons.mic : Icons.mic_off,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(50), // Ajusta el valor según sea necesario
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
