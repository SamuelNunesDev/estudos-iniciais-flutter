class TarefaRecurso {
  TarefaRecurso.fromMap(Map<dynamic, dynamic> tarefaMap) {
    titulo = tarefaMap['titulo'];
    concluida = tarefaMap['concluida'];
  }
  TarefaRecurso.fromString(String tarefa) {
    titulo = tarefa;
  }

  late final String titulo;
  late bool concluida = false;

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "concluida": concluida
    };
  }
}