import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: Container(),
  ));
}

class ConversorMoedas extends StatefulWidget {
  const ConversorMoedas({super.key});

  @override
  State<ConversorMoedas> createState() => _ConversorMoedasState();
}

class _ConversorMoedasState extends State<ConversorMoedas> {
  _ConversorMoedasState() {
    buscarCotacoesMoedas();
  }


  Future<Map<String, dynamic>> buscarCotacoesMoedas() async {
    http.Response response = await http.get(
      Uri.https(
        'a158-177-130-189-94.ngrok-free.app',
        'api/v1/samuel/mock',
      ),
    );
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
