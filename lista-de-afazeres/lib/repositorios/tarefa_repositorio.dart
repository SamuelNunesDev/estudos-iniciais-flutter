import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lista_de_afazeres/modelos/tarefa_modelo.dart';

const chaveTarefas = 'tarefas';

class TarefaRepositorio {
  late SharedPreferences preferencias;

  void salvarTarefas(List<TarefaModelo> tarefas) {
    preferencias.setString(chaveTarefas, json.encode(tarefas));
  }

  Future<List<TarefaModelo>> tarefasUsuario() async {
    preferencias = await SharedPreferences.getInstance();
    List tarefas = json.decode(preferencias.getString(chaveTarefas) ?? '[]') as List;

    return tarefas.map((tarefa) => TarefaModelo.JSON(tarefa)).toList();
  }
}