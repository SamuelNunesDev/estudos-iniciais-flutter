import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lista_tarefas/recursos/tarefa_recurso.dart';

class PaginaInicialController extends GetxController {
  PaginaInicialController() : super() {
    carregarTarefas();
  }

  var listaTarefas = [].obs;
  final GetStorage box = GetStorage();

  void criarTarefa(String tarefa) {
    final TarefaRecurso novaTarefa = TarefaRecurso.fromString(tarefa);
    listaTarefas.add(novaTarefa);
    salvarLista();
  }

  void carregarTarefas() {
    String? lista = box.read('lista');
    List<TarefaRecurso> listaTarefaRecurso = [];
    if (lista is String) {
      List<dynamic> listaTarefas = json.decode(lista);
      listaTarefaRecurso =
          listaTarefas.map((e) => TarefaRecurso.fromMap(e)).toList();
    }
    listaTarefas.addAll(listaTarefaRecurso);
  }

  void alterarTarefa(bool concluida, TarefaRecurso tarefa) {
    final indexTarefa = listaTarefas.indexOf(tarefa);
    listaTarefas.removeAt(indexTarefa);
    tarefa.concluida = concluida;
    listaTarefas.insert(indexTarefa, tarefa);
    salvarLista();
  }

  void salvarLista() {
    box.write('lista', json.encode(listaTarefas));
  }

  void deletarTarefa(BuildContext context, int index) {
    final Map<String, dynamic> tarefaRemovida = {
      "index": index,
      "tarefa": listaTarefas[index]
    };
    listaTarefas.removeAt(index);
    salvarLista();

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'A tarefa ${tarefaRemovida['tarefa'].titulo} foi removida com sucesso.',
        ),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            listaTarefas.insert(
              tarefaRemovida['index'],
              tarefaRemovida['tarefa'],
            );
            salvarLista();
          },
        ),
      ),
    );
  }

  Future<void> ordenarTarefas() async {
    await Future.delayed(const Duration(seconds: 1));
    listaTarefas.sort((a, b) {
      if(a.concluida && !b.concluida) {
        return 1;
      } else if(!a.concluida && b.concluida) {
        return -1;
      }
      return 0;
    });
  }
}
