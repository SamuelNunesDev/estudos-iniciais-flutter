import 'package:flutter/material.dart';
import 'package:lista_de_afazeres/modelos/tarefa_modelo.dart';
import 'package:lista_de_afazeres/repositorios/tarefa_repositorio.dart';
import 'package:lista_de_afazeres/widgets/tarefa_widget.dart';

const corPrimaria = Color(0xff00d7f3);

class ListaTarefas extends StatefulWidget {
  const ListaTarefas({super.key});

  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  final TextEditingController tarefaAdicionar = TextEditingController();
  final TarefaRepositorio tarefaRepositorio = TarefaRepositorio();
  List<TarefaModelo> _tarefas = [];
  String? erroAdicionarTarefa;

  @override
  void initState() {
    super.initState();
    tarefaRepositorio.tarefasUsuario().then((tarefas) {
      setState(() {
        _tarefas = tarefas;
      });
    });
  }

  void adicionarTarefaState() {
    if (tarefaAdicionar.text.isNotEmpty) {
      setState(() {
        erroAdicionarTarefa = null;
        _tarefas.add(TarefaModelo(tarefaAdicionar.text, DateTime.now()));
      });
      tarefaAdicionar.clear();
      tarefaRepositorio.salvarTarefas(_tarefas);
    } else {
      setState(() {
        erroAdicionarTarefa = 'O nome da tarefa é obrigatório!';
      });
    }
  }

  void adicionarTarefa() {
    adicionarTarefaState();
  }

  void adicionarTarefaFormulario(String texto) {
    adicionarTarefaState();
  }

  void limparTarefas() {
    final List<TarefaModelo> tarefasTemp = List.from(_tarefas);

    setState(() {
      _tarefas.clear();
    });
    tarefaRepositorio.salvarTarefas(_tarefas);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${tarefasTemp.length} tarefa${tarefasTemp.length > 1 ? 's' : ''} excluída${tarefasTemp.length > 1 ? 's' : ''} com sucesso!',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _tarefas.addAll(tarefasTemp);
            });
            tarefaRepositorio.salvarTarefas(_tarefas);
          },
          textColor: Colors.white,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void deletarTarefa(TarefaModelo tarefa) {
    int indexTarefaRemovida = _tarefas.indexOf(tarefa);
    setState(() {
      _tarefas.remove(tarefa);
    });
    tarefaRepositorio.salvarTarefas(_tarefas);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${tarefa.titulo} excluída com sucesso.',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () => desfazerExclusaoTarefa(indexTarefaRemovida, tarefa),
          textColor: Colors.white,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void desfazerExclusaoTarefa(int index, TarefaModelo tarefa) {
    setState(() {
      _tarefas.insert(index, tarefa);
    });
    tarefaRepositorio.salvarTarefas(_tarefas);
  }

  void mostarAlertaLimparTudo() {
    if (_tarefas.isEmpty) {
      exibirMensagemSemTarefas();

      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content: const Text('Tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: corPrimaria,
              ),
            ),
          ),
          TextButton(
            onPressed: limparTarefas,
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void exibirMensagemSemTarefas() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Você não possui nenhuma tarefa cadastrada.',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tarefaAdicionar,
                        onSubmitted: adicionarTarefaFormulario,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Adicione uma Tarefa',
                          hintText: 'Ex: Estudar Flutter',
                          errorText: erroAdicionarTarefa,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: corPrimaria,
                              width: 2,
                            ),
                          ),
                          labelStyle: const TextStyle(color: corPrimaria)
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: adicionarTarefa,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corPrimaria,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (TarefaModelo tarefa in _tarefas)
                        TarefaWidget(tarefa, deletarTarefa)
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${_tarefas.length} tarefas pendentes.',
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: mostarAlertaLimparTudo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corPrimaria,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text('Limpar Tudo'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
