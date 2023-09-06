class TarefaModelo {
  TarefaModelo(this.titulo, this.data);
  TarefaModelo.JSON(Map<String, dynamic> tarefa) {
    titulo = tarefa['titulo']!;
    data = DateTime.parse(tarefa['data']!);
  }

  late String titulo;
  late DateTime data;

  Map<String, String> toJson() {
    return {
      'titulo': titulo,
      'data': data.toIso8601String()
    };
  }
}