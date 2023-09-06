import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lista_tarefas/telas/pagina_inicial.dart';

void main() async {
  await GetStorage.init();

  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaInicial(),
    ),
  );
}

