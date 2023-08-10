import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

const estilosPadroesTexto = TextStyle(color: Colors.green, fontSize: 25);
const espacamentoPadrao = SizedBox(height: 15);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  GlobalKey<FormState> _formularioIMC = GlobalKey<FormState>();
  String _textoInfo = '';

  InputDecoration estilosPadroesEntradaDeTexto(String texto) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green,
        ),
      ),
      labelText: texto,
      labelStyle: const TextStyle(
        color: Colors.green,
      )
    );
  }

  void _resetarCampos() {
    pesoController.text = '';
    alturaController.text = '';
    setState(() {
      _textoInfo = '';
      _formularioIMC = GlobalKey<FormState>();
    });
  }

  void _calcularIMC() {
    if (!(_formularioIMC.currentState?.validate() == true)) {
      return;
    }
    double? peso = double.parse(pesoController.text.replaceAll(',', '.'));
    double? altura = double.parse(alturaController.text.replaceAll(',', '.'));
    double imc = peso / pow(altura / 100, 2);
    late String textoIMC;
    if (imc < 18.5) {
      textoIMC = 'Magreza';
    } else if (imc < 24.9) {
      textoIMC = 'Normal';
    } else if (imc < 29.9) {
      textoIMC = 'Sobrepeso';
    } else if (imc < 39.9) {
      textoIMC = 'Obesidade';
    } else {
      textoIMC = 'Obesidade Grave';
    }
    textoIMC += ' (${imc.toStringAsFixed(1)})';
    setState(() {
      _textoInfo = textoIMC;
    });

  }

  String? _validarDouble(String? valor) {
    if (valor == null ||
        valor.isEmpty ||
        double.tryParse(valor.replaceAll(',', '.')) == null) {
      return 'Insira um valor válido.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Calculadora de IMC'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: _resetarCampos,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formularioIMC,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 150,
                  color: Colors.green,
                ),
                TextFormField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: estilosPadroesEntradaDeTexto('Peso (kg)'),
                  textAlign: TextAlign.center,
                  style: estilosPadroesTexto,
                  validator: _validarDouble,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: alturaController,
                  keyboardType: TextInputType.number,
                  decoration: estilosPadroesEntradaDeTexto('Altura (cm)'),
                  textAlign: TextAlign.center,
                  style: estilosPadroesTexto,
                  validator: _validarDouble,
                ),
                espacamentoPadrao,
                Container(
                  height: 50,
                  child: TextButton(
                    onPressed: _calcularIMC,
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'Calcular',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                espacamentoPadrao,
                Text(
                  _textoInfo,
                  textAlign: TextAlign.center,
                  style: estilosPadroesTexto,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
